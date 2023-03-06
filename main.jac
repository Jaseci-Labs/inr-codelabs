import {*} with "./graph.jac";
import {*} with "./posts/posts_walkers.jac";
import {*} with "./tags/tags_walkers.jac";

walker init {

    root {
        take --> node::app_root else { spawn here ++> graph::app_graph; }
    }
}