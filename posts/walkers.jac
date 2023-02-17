walker import_news_data {
    has file_path;

    can file.load_json;
    can file.dump_json;

    root: take -->[0];
    app_root: take --> node::posts;
    posts{
        post_nodes = --> node::post;
        for n in post_nodes: destroy n; // delete all post nodes

        news_posts = file.load_json(file_path); //get list of news posts

        for n in news_posts{
            nd = spawn node::post(title = n["title"], description = n["description"], source = n["source"], link = n["link"], image = n["image"], published = n["published"], code = n["code"]); // creates node
            n["id"] = nd.info['jid']; // updates id
            file.dump_json(file_path, news_posts);  // updates json file
            here +[posts_post(id = nd.info['jid'])]+> nd;
            report nd;
        }
    }
}

# creates a post node and appends it to news_posts.json file
walker create_post {
    
    has title;
    has description;
    has source;
    has link;
    has image;
    has published;
    has code;

    can file.load_json;
    can file.dump_json;

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

        news_posts = file.load_json('./posts/news_posts.json'); //get list of news posts
        new_post = {
            "id": nd.info['jid'],
            "title": nd.title,
            "description": nd.description,
            "source": nd.source,
            "link": nd.link,
            "image": nd.image,
            "published": nd.published,
            "code": nd.code
        };
        news_posts.list::append(new_post); // add new post to list of posts
        file.dump_json('./posts/news_posts.json', news_posts);  // updates json file
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

    can file.load_json;
    can file.dump_json;

    post {

        if(title): here.title = title;
        if(description): here.description = description;
        if(source): here.source = source;
        if(link): here.link = link;
        if(image): here.image = image;
        if(published): here.published = published;
        if(code): here.code = code;

        news_posts = file.load_json('./posts/news_posts.json'); //get list of news posts
        for n in news_posts{
            if (n["id"] == here.info['jid']){
                n["title"] = here.title;
                n["description"] = here.description;
                n["source"] = here.source;
                n["link"] = here.link;
                n["image"] = here.image;
                n["published"] = here.published;
                n["code"] = here.code;

                break;
            }
        }

        file.dump_json('./posts/news_posts.json', news_posts);  // updates json file
        report here;
    }

}

# deletes post node; node jid must be specified in nd param
walker delete_post {
    can file.load_json;
    can file.dump_json;
    post {
        report here;

        news_posts = file.load_json('./posts/news_posts.json'); //get list of news posts
        for n in news_posts{
            if (n["id"] == here.info['jid']){
                news_posts.list::remove(n);    //deletes post from list
                break;
            }
        }

        file.dump_json('./posts/news_posts.json', news_posts);  // updates json file

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
        for n in post_nodes: n.summary = t5_sum.classify_text(text = n.description, min_length = min_len, max_length = max_len);
        report post_nodes;
        disengage;
    }
}