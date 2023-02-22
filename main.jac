import {*} with "./graph.jac";
import {*} with "./posts/walkers.jac";
import {*} with "./tags/walkers.jac";

walker init {

    root {
        take --> node::app_root else { spawn here ++> graph::app_graph; }
    }
}