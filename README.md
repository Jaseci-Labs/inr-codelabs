Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands in __*WSL T1*__:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`


# Codelab-2.1

## Summary

* Building on the previous codelab,
* We need to clean up the news data on the fly; strip some HTML tags, etc. 
* Let’s create a custom Jaseci action module that houses some python code that we can use to strip html tags and other special characters. 


## Recording

Here's the recording for codelab-2.1: [Jaseci AI Mentorship Sessions-20230301_113218-Meeting Recording.mp4](https://v75corp-my.sharepoint.com/personal/eldon_marks_v75inc_com/_layouts/15/stream.aspx?id=%2Fpersonal%2Feldon%5Fmarks%5Fv75inc%5Fcom%2FDocuments%2FRecordings%2FJaseci%20AI%20Mentorship%20Sessions%2D20230301%5F113218%2DMeeting%20Recording%2Emp4&ga=1)


## Tag riddled news posts, yuk!

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_news_posts_1.png?raw=true)

Did you notice that news posts data has HTML tags, escape characters, etc in the description? That's what we have to solve!


## Build Actions Module

The first thing that we do, is build our actions module, which will be in a python script. Let's call it __inr_actions.py__

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_inr_actions.png?raw=true)

When building your own custom module, line 1 is very important!

`from jaseci.actions.live_actions import jaseci_action`

It allows a regular python function to be referenced as a jaseci action.


## Loading the custom module

Once you are logged in and the action is defined, we'll have to run this command to load it:

`actions load local inr_actions.py`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_load_inr_actions.png?raw=true)

You can run `actions list`, to see the list of loaded actions. You should see the local action towards the end of that list.

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_actions_list_1.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_actions_list_2.png?raw=true)


## Declaring the local action

We'll be using this action in __import_news_data__ walker. First, we need to declare it.

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_declare_action.png?raw=true)


## Using the local action

We'll call __remove_html_tags__ on the description, which will give a cleaner output in the node itself.

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_call_action.png?raw=true)


## Build and update

We've modified the JAC source. Do you know what that means? We'll have to rebuild and update the sentinel!

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_rebuild.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_update_sentinel.png?raw=true)


## Execute import_news_data walker, again

We'll run __import_news_data__ again. It will clear the graph and reimport the news posts; this time, it will be cleaner (without HTML tags).

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_import_news_data.png?raw=true)


## Execute summarize_posts walker, again

This time, we've changed the parameters

`walker run summarize_posts -ctx "{\"min_len\": 20, \"max_len\": 50 }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_summarize_posts.png?raw=true)


## Now we have clean text and summaries

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_import_news_data_result.png?raw=true)


## Check out the updated Graph

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_updated_graph_1.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-2.1/images/c2_updated_graph_2.png?raw=true)