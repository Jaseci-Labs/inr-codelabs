walker import_news_data {
    has file_path;

    can file.load_json;
    can inr.remove_html_tags;

    root: take -->[0]; //if at root, walk to app_root node
    app_root: take --> node::posts; //if at app_root, walk to posts node

    posts { //while on the posts node...
        post_nodes = --> node::post; //grabs all connected post nodes connected to 'posts' as a list
        for n in post_nodes: destroy n; // delete all post nodes

        try {
            news_posts = file.load_json(file_path); //get list of news posts
            
            for n in news_posts {

                // create post node with content from JSON
                nd = spawn node::post(
                    title = n["title"], 
                    description = inr.remove_html_tags(text = n["description"]), 
                    source = n["source"], 
                    link = n["link"], 
                    image = n["image"], 
                    published = n["published"], 
                    code = n["code"]); 

                //connect the new post node to the posts node that we're currently on
                //with an edge that is described by the id of the posts node
                here +[posts_post(id = nd.info['jid'])]+> nd; 

                //return the created node
                report nd;
            }

        } else {
            report:status = 400;
            report "Invalid file path";
            disengage; 
        }
    }
}


# creates a post node
walker create_post {
    
    has title;
    has description;
    has source;
    has link;
    has image;
    has published;
    has code;

    root: take -->[0];
    app_root: take --> node::posts;

    posts {
        
        if(!title || !description || !source || !published || !code) {
            report:status = 400;
            report "Missing required parameters";
            disengage;
        }

        // creates node
        nd = spawn node::post(
            title = title, 
            description = description, 
            source = source, 
            published = published, 
            code = code);

        if(link): nd.link = link;
        if(image): nd.image = image;

        here +[posts_post(id = nd.info['jid'])]+> nd; // creates the edge connected to posts node

        report nd;

        disengage;
    }

}

#updates a created post; nd must be specified along with optional params in the ctx param
walker update_post {

    has title;
    has description;
    has source;
    has link;
    has image;
    has published;
    has code;

    post {

        if(title): here.title = title;
        if(description): here.description = description;
        if(source): here.source = source;
        if(link): here.link = link;
        if(image): here.image = image;
        if(published): here.published = published;
        if(code): here.code = code;

        report here;
        disengage;
    }

}


# deletes post node; node jid must be specified in nd param
walker delete_post {
    post {
        report here;
        destroy here;
        disengage;
    }
}

#returns post node; node jid must be specified in nd param
walker get_post {
   post {
        report here;
        disengage;
    }

}

walker list_posts {
    has paginated = false;
    has limit = 10;
    has offset = 0;
    
    root: take -->[0];
    app_root: take --> node::posts;
    posts{
        report --> node::post;
        disengage;
    }
}

walker summarize_posts {
    // declare action
    can t5_sum.classify_text;
    has min_len;
    has max_len;

    // head to branch posts node
    root: take -->[0];
    app_root: take --> node::posts;

    posts{
        // grab list of posts
        post_nodes = --> node::post;

        // for each post that doesn't have a summary, generate a summary from the description and save it in summary attribute
        for n in post_nodes {
            if(!n.summary): n.summary = t5_sum.classify_text(text = n.description, min_length = min_len, max_length = max_len);
            std.log(n.summary);
            report n;
        }
        disengage;
    }
}

// walk through all posts,
// for each post, identify which tags are applicable and establish edges between them
walker tag_posts {

    root: take -->[0];
    app_root: take --> node::posts;

    posts {
        take --> node::post;
    }

    post {
        spawn here walker::apply_tags;
    }
}

// takes a post and applies the best tags to it
walker apply_tags {

    can use.text_classify;
    has min_confidence = 0.1;
    has _post;

    root: take -->[0];
    app_root: take --> node::tags;

    post {
        _post = here;
        std.log("grabbed post node: " + _post.title);
        take net.root(); //head back to root
    }

    tags {
        take --> node::tag;
    }

    tag {
        std.log("examining tag: " + here.label);

        result = use.text_classify(
            text = _post.title,
            classes = -[tag_statement]->.text // pluck text value from nodes connected by tag_statement edges as list
        );

        // grab index of match with highest score
        match_index = result["match_idx"];
        // grab the score
        confidence = result["scores"][match_index];

        // if it makes our acceptance confidence level, we consider it
        if (confidence >= min_confidence) {

            //establish the edge, if it doesnt exist
            if( _post in <-[tag_post]-> ): std.log("already added tag " + here.label);
            else: _post <+[tag_post(confidence = confidence)]+> here;

        } else {
            std.log("confidence too low, skipping");
        }
    }
}


walker semantic_search {
    has query;
    has min_confidence = 0.15;

    can use.qa_similarity;

    root: take -->[0];
    app_root: take --> node::posts;

    posts {
        
        if(!query) {
            report:status = 400;
            report "Missing required parameter";
            disengage;
        }

        take --> node::post;
    }

    post {
        cos_score = use.qa_similarity(text1 = here.summary, text2 = query);
        if(cos_score >= min_confidence) {
            report {"score": cos_score, "post": here};
        }
    }
 
}

// extract entities from query inputted by user
walker entity_search {
    has utterance;
    has entities = {};

    can extract_entities {
        
        try {
            entity_list = file.load_json(global.entity_list);
        } else {
            std.log("Could not load entity list.");
        }

        if(entity_list) {
            res = tfm_ner.extract_entity(utterance);

            //prepare a standard way of organizing extracted entities inside of the walker
            //this can be modified if we swap out the NER without altering dependencies in the implementing app
            if(res.type == list || res.type == dict) {
                for entity in res {
                    if(entity["conf_score"] >= global.min_ner_confidence) {
                        entity_label = entity["entity_value"];
                        entity_text = entity["entity_text"];
                        entity_confidence = entity["conf_score"];
                        
                        if(entity_label in entity_list) { 
                            //only consider valid entities based on entity_list.json
                            //update the collection of entities in the walker, 
                            //appending new entity_texts to existing entity_labels
                            if(entity_label not in entities) {
                                entities[entity_label] = [{"text": entity_text, "confidence":entity_confidence}];
                            } else {
                                texts = entities[entity_label];

                                for item in texts {   
                                    if(entity_text not in item["text"]) {
                                        entities[entity_label] += [{"text":entity_text, "confidence":entity_confidence}]; 
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }      

    }

    // extract entities then we filter posts and report
    ::extract_entities;
    report spawn net.root() walker::filter_posts_by_entities(entities = entities);
}