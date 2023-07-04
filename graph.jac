import {*} with "./posts/posts_graph.jac";
import {*} with "./tags/tags_graph.jac";

import {*} with "./dialog/dialog_graph.jac"; 
import {*} with "./semantic_search/semantic_search_dialog_graph.jac"; 
import {*} with "./entity_search/entity_search_dialog_graph.jac"; 

node app_root;

graph app_graph {

    has anchor app_root;

    spawn {
        app_root = spawn node::app_root;
        posts = spawn app_root ++> node::posts;
        tags = spawn app_root ++> node::tags;

        sessions = spawn app_root ++> node::sessions;
        dialog_root = spawn app_root ++> node::dialog_root;
        greet = spawn dialog_root +[intent_transition(intent = "greet")]+> node::greet;
        dialog_end = spawn dialog_root ++> node::dialog_end;

        semantic_search = spawn dialog_root +[intent_transition(intent = "semantic_search")]+> node::semantic_search_state;
        entity_search = spawn dialog_root +[intent_transition(intent = "entity_search")]+> node::entity_search_state;
    }

}