walker import_news_data {
    has file_path;

    root: take -->[0];
    app_root: take --> node::posts;
    posts{
        post_nodes = --> node::post;
        for n in post_nodes: destroy n; // delete all post nodes
        news_posts = file.load_json(file_path); //get list of news posts

        for i=0 to i<news_posts.length by i += 1: news_posts[i]["id"] = (i+1).str; // changes id
        file.dump_json(file_path, news_posts);  // updates json file

        for n in news_posts{
            nd = spawn node::post(id = n["id"].str, title = n["title"], description = n["description"], source = n["source"], link = n["link"], image = n["image"], published = n["published"], code = n["code"]); // creates node
            here +[posts_post(id = n["id"].str)]+> nd;
            report nd;
        }
    }
}

walker create_post {
    
    has id;
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
        news_posts = file.load_json('./posts/data.json'); //get list of news posts
        if news_posts.length > 0: next_id = news_posts[-1]["id"].int+1; else: next_id = 1; //finding the next id
        new_post = {
            "id": next_id.str,
            "title": title,
            "description": description,
            "source": source,
            "link": link,
            "image": image,
            "published": published,
            "code": code
        };
        news_posts.list::append(new_post); // add new post to list of posts
        file.dump_json('./posts/data.json', news_posts);  // updates json file
        nd = spawn node::post(id = next_id.str, title = title, description = description, source = source, link = link, image = image, published = published, code = code); // creates node
        here +[posts_post(id = next_id.str)]+> nd;
        report nd;

        disengage;
    }

}

walker update_post {
    
    has id;
    has title;
    has description;
    has source;
    has link;
    has image;
    has published;
    has code;

    if(!id) {
        report:status = 400;
        report "Missing required parameters.";
        disengage;
    }

    root: take -->[0];
    app_root: take --> node::posts;
    posts: take -[posts_post(id == id.str)]-> node::post else: report:status = 404;

    post {
        
        if(title): here.title = title;
        if(description): here.description = description;
        if(source): here.source = source;
        if(link): here.link = link;
        if(image): here.image = image;
        if(published): here.published = published;
        if(code): here.code = code;

        ids = [];
        news_posts = file.load_json('./posts/data.json'); //get list of news posts
        for n in news_posts: ids.list::append(n["id"]); // make a list of ids
        post_index = ids.list::index((here.id).str);  // get index/position of post in array
        updated_post = {
            "id": (here.id).str,
            "title": here.title,
            "description": here.description,
            "source": here.source,
            "link": here.link,
            "image": here.image,
            "published": here.published,
            "code": here.code
        };
        news_posts[post_index] = updated_post;
        file.dump_json('./posts/data.json', news_posts);  // updates json file
        report here;
        disengage;
    }

}

walker delete_post {
    
    has id;

    if(!id) {
        report:status = 400;
        report "Missing required parameters.";
        disengage;
    }

    root: take -->[0];
    app_root: take --> node::posts;
    posts: take -[posts_post(id == id.str)]-> node::post else: report:status = 404;

    post {
        ids = [];
        news_posts = file.load_json('./posts/data.json'); //get list of news posts
        for n in news_posts: ids.list::append(n["id"]); // make a list of ids
        post_index = ids.list::index((here.id).str);  // get index/position of post in array
        report here;
        news_posts.list::remove(news_posts[post_index]);    //deletes post from list
        file.dump_json('./posts/data.json', news_posts);    //updates json file
        destroy here;
        disengage;
    }

}

walker get_post {
    
    has id;

    if(!id) {
        report:status = 400;
        report "Missing required parameters.";
        disengage;
    }

    root: take -->[0];
    app_root: take --> node::posts;
    posts: take -[posts_post(id == id.str)]-> node::post else: report:status = 404;

    post {
        report here;
        disengage;
    }

}

walker get_posts {
    root: take -->[0];
    app_root: take --> node::posts;
    posts{
        post_nodes = --> node::post;
        report post_nodes;
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