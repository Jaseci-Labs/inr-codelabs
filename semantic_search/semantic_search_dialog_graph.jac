node semantic_search_state:dialog_state {
    has name = "semantic_search";

    can nlu {}

    can process {
        # nothing to process here, be sure to send the walker back to the dialog root when complete
        visitor.next_state = (net.root()).info["jid"];
    }

    can nlg {
        # we call our original semantic_search walker and pass to it the utterance that comes in from the talker walker
        results = spawn net.root() walker::semantic_search(query=visitor.utterance);
        # we'll return the resultset if we have one, otherwise, we tell the user we've got nothing...
        if(results): visitor.response = results;
        else: visitor.response = "There are no results for: '" + visitor.utterance +"'";
    }
}