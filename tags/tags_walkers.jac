#creates a tag connected to the tags node; creates a tag connected to a parent tag (node jid of parent tag must be specified in nd param)
walker create_tag {

    has label;

    root: take -->[0];
    app_root: take --> node::tags;

    tags, tag {
        
        if(!label) {
            report:status = 400;
            report "Missing required parameters";
            disengage;
        }

        nd = spawn node::tag(label = label); // creates node
        here +[tags_tag(id = nd.info['jid'])]+> nd; // creates the edge connected to tags node

        report nd;

        disengage;
    }
}

#updates a created tag; nd must be specified along with optional params in the ctx param
walker update_tag {

    has label;

    tag {

        if(label): here.label = label;
        report here;
        disengage;
    }

}

# deletes tag node; node jid must be specified in nd param
walker delete_tag {
    tag: report here;
    tag, statement {
        take -->;
        destroy here;
    }
}

#returns tag node; node jid must be specified in nd param
walker get_tag {
   tag {
        report here;
        disengage;
    }

}

walker list_tags {
    has paginated = false;
    has limit = 10;
    has offset = 0;
    has recursive = true;

    has all_tags = [];
    tags = [];
    
    root: take -->[0];
    app_root: take --> node::tags;
    tags, tag{
        if(recursive): take -->;
        tags = --> node::tag;
        for tag in tags: all_tags.list::append(tag);
        // report --> node::tag;
        // disengage;
    }

    report all_tags;
}

# creates a statement for a tag; node jid of tag must be specified in nd param
walker create_tag_statement {
    has statement;

    tag {
        
        if(!statement) {
            report:status = 400;
            report "Missing required parameters";
            disengage;
        }

        nd = spawn node::statement(statement = statement); // creates node
        here +[tag_statement(id = nd.info['jid'])]+> nd; // creates the edge connected to tag node

        report nd;

        disengage;
    }
}

#updates a statement; nd must be specified along with optional params in the ctx param
walker update_tag_statement {
    has statement;

    statement {
        if(statement): here.statement = statement;
        report here;
        disengage;
    }
}

# deletes statement node; node jid must be specified in nd param
walker delete_tag_statement {
    statement {
        report here;
        destroy here;
        disengage;
    }
}

#returns statement node; node jid must be specified in nd param
walker get_tag_statement {
   statement {
        report here;
        disengage;
    }

}

#returns list of statement node; tag node jid must be specified in nd param
walker list_tag_statement {
    has paginated = false;
    has limit = 10;
    has offset = 0;

    tag {
        report --> node::statement;
        disengage;
    }
}