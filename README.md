Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`


# Codelab-2

## Summary

* Building on the previous codelab,
* we introduce loading and using a specialized AI model which performs text summarization. 
* A specialized walker will be built which leverages this model and walks the graph of news items, updating them with summarizations of their content.



## Install NLP modules

You'll need to install the jac_nlp module:

`pip install jac_nlp[all]`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_install_nlp.png?raw=true)

If you encountered an error while trying to install package - sentencepiece, then run the following 3 commands:

`sudo apt-get install pkg-config`

`sudo apt-get install cmake`

`pip install sentencepiece`

Now, try running `pip install jac_nlp[all]` again.


## Load the t5_sum module

After logging in, we'll need to load the t5_sum module

`actions load module jac_nlp.t5_sum`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_load_t5_sum.png?raw=true)


This might take a while, especially if you're running it for the first time.

## Build and update

`jsctl jac build main.jac`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_build.png?raw=true)

Note: You must run this command, every time a change is made to your code.

If you have already registered the sentinel, then just run:

`sentinel set -snt active:sentinel -mode ir main.jir`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_update_sentinel.png?raw=true)

You'll need to run this command after you build.


## Execute import_news_data walker, again

To run this walker, enter the following command in the jaseci terminal: 

`walker run import_news_data -ctx "{\"file_path\": \"news_posts.json\" }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_execute_import_newsdata.png?raw=true)

You should get a similar result like this: 

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_import_newsdata_result.png?raw=true)


## Execute summarize_posts walker

To run this walker, enter the following command in the jaseci terminal: 

`walker run summarize_posts -ctx "{\"min_len\": 50, \"max_len\": 100 }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_execute_summarize_posts.png?raw=true)

You should get a similar result like this: 

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_summarize_posts_result.png?raw=true)


## Check out the updated Graph

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c2_updated_graph.png?raw=true)


## walker summarize_posts

``` JSON
{
    "name": "summarize_posts",
    "ctx": {
        "min_len": 50,
        "max_len": 100
    },
    "_req_ctx": {},
    "snt": "my_sentinel_id",
    "profiling": false,
    "is_async": false
}
```