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

// generates the embeddings for an array of text
walker umap_cluster {
    can use.encode;
    can cluster.get_umap;
    
    has list_of_text;
    has anchor embeddings;

    embeddings = cluster.get_umap(use.encode(list_of_text),15, 0.1, 2, 42);
}

// allows you to generate hbdscan clusters based on the umap embeddings
walker hbdscan_clusterings {
    can cluster.get_cluster_labels;
    can cluster.get_umap;
    can use.encode;

    has umap_embeddings;
    has anchor clusters;

    clusters = cluster.get_cluster_labels(umap_embeddings,"hbdscan",2,2); 
}

// allows you to generate kmeans clusters based on the umap embeddings
walker kmean_clusterings {
    can cluster.get_umap;
    can use.encode;

    has umap_embeddings;
    has anchor clusters;

    clusters = cluster.get_cluster_labels(umap_embeddings,"kmeans",2,2, n_clusters);
}

walker posts_cluster {
    has list_of_summary = [];
    has cluster_method = "hbdscan";
    has clusters;
    has n_clusters = 3;
    has results = [];

    can getClusterResults {
        // creates a list of dictionaries, listing all the posts (nodes) for each cluster
        c = [];
        for i=0 to i < clusters.length by i += 1 {
            if (clusters[i] not in c){
                c.list::append(clusters[i]);
                results.list::append(
                {
                    "cluster": clusters[i],
                    "list": []
                }
                );
            }
            for r in results {
                if (r["cluster"] == clusters[i]){
                    r["list"].list::append(list_of_posts[i]);
                    break;
                }

            }
        }
    }

    root: take -->[0];
    app_root: take --> node::posts;
    posts{
        post_nodes = --> node::post;
        for p in post_nodes: list_of_summary.list::append(p.summary); // creates a list of posts' summary
        if(list_of_summary.length <= 0){
            report "No posts found! Please add a post.";
            disengage;
        }
        umap_embeddings = spawn here walker::umap_cluster(list_of_text=list_of_summary); // creates a lists of embeddings using summary
        if (cluster_method == "hbdscan") {
            hdb_data = spawn here walker::hbdscan_clusterings(umap_embeddings=umap_embeddings);
            ::getClusterResults(clusters = hdb_data, list_of_posts=post_nodes);
            take -->;
        }
        elif (cluster_method == "kmean"){
            kmean_data = spawn here walker::kmean_clusterings(umap_embeddings=umap_embeddings, n_clusters=n_clusters);
            ::getClusterResults(clusters = kmean_data, list_of_posts=post_nodes);
            take -->;
        }
        else{
            report "cluster_method must be either 'hbdscan' or 'kmean'.";
            disengage;
        }
    }

    post {
        for i in results {
            if (here in i["list"]) {
                related_posts_list = i["list"]; // list of all posts related to current post
                related_posts = -[related]-> node::post; //  list of related posts connected to current post
                for p in related_posts_list {
                    if (p not in related_posts): here <+[related]+> p;
                }
            }
        }
    }
}

walker get_related_posts {
    post {
        report -[related]-> node::post;
    }
}