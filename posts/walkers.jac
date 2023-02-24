walker import_news_data {
    has file_path;

    can file.load_json;

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
                    description = n["description"], 
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

        nd = spawn node::post(title = title, description = description, source = source, published = published, code = code); // creates node
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
    can t5_sum.classify_text;
    has min_len;
    has max_len;

    root: take -->[0];
    app_root: take --> node::posts;
    posts{
        post_nodes = --> node::post;
        for n in post_nodes {
            if(!n.summary): n.summary = t5_sum.classify_text(text = n.description, min_length = min_len, max_length = max_len);
            report n;
        }
        disengage;
    }
}

// must run walker summarize_posts before running this walker
walker classify_posts {
    can use.text_classify;

    has post_nodes = [];
    has all_tags = [];
    has classes = [];

    root: take -->[0];
    app_root{
        take--> node::tags;
        take --> node::posts;
    }
    
    tags: take -->;

    tag {
        statement_nodes = --> node::statement;
        tag_statements = [];
        for st_node in statement_nodes{
            tag_statements.list::append(st_node.info["context"]["statement"]);
            classes.list::append(st_node.info["context"]["statement"]);
        }
        t = {
            "tag_id": here.info['jid'],
            "tag": here.label,
            "statement": tag_statements
        };
        all_tags.list::append(t);
        take -->;
    }

    posts: post_nodes = --> node::post;

    if (classes.length > 0):
    for n in post_nodes {
        post_tag_id = "";
        resp = use.text_classify(
            text = n.summary,
            classes = classes
        );

        for tag in all_tags{
            if (resp["match"] in tag["statement"]){
                post_tag_id = tag["tag_id"];
            }
        }
        n <+[post_tag(id = post_tag_id)]+> *post_tag_id; // edge from post to tag
    }

}