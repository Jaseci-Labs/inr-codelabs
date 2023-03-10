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
