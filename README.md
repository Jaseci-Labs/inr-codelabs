Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`


# Codelab-1

## Summary

* Skeleton of the app will be built out;
* advised folder structure, naming conventions will be conveyed; 
* sample news post dataset will be provided in the form of JSON file; 
* Code thru objective will be to step through building: 
    * the graph structure to organize the news post data,
    * the walker which imports the data and spawns the graph
    * other walkers which provide complementing CRUD operations on graph data
* Interacting with your JAC app via the API will be covered
* Jaseci Studio will be introduced to visualize the imported graph data in the Jaseci graph.


## Build and Test it!

The first objective here is to get the jaseci-serv running. To do this, you'll run the following commands: 

`jsserv makemigrations base`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_make_migrations.png?raw=true)


`jsserv migrate`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_jsserv_migrate.png?raw=true)


In django, it's going to set up the necessary structures to run your JAC application.

Once that is set up, we need to create the superuser for your JAC application.

Run the following command:

`jsserv createsuperuser`

Enter your email and password as prompted.

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_createsuperuser.png?raw=true)

Once the superuser is created, you can run your server: 

`jsserv runserver`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_runserver.png?raw=true)

Note: When the server is running, you should leave that terminal alone. Any other commands, should be executed in another terminal. 

In a new terminal, run `jsctl -m` 

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_start_jsctl.png?raw=true)

This will start the jaseci shell, which will be used to login to the server.

Once you have the jaseci shell running, run the command:

`jac build main.jac`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_build.png?raw=true)


Next, you'll login to the server: 

`login http://localhost:8000`

Enter username and password of superuser created above.

If login successful, a token should be generated. We'll refer to this as ***my_token***. This will be needed to make requests to the API via Postman. See the [Postman section](#Postman "Go to Postman section") below for more information.

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_jsctl_login.png?raw=true)


Now, you are reaady to register the sentinel: 

`sentinel register -name main -mode ir main.jir`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_register_sentinel.png?raw=true)

Note: sentinel register should only be executed once. sentinel set should be used for every subsequent change and recompilation.

We'll refer to the sentinel's jid as ***my_sentinel_id***. This will also be needed to make requests to the API via Postman.


## Visualizing the graph using Jaseci Studio

Download and install the latest version of the [Jaseci Studio](https://github.com/Jaseci-Labs/jaseci/releases) application, based on your Operating System.

Once Jaseci Studio is running, you'll need to enter host, port, email and password (for the superuser) and then click 'Test Connection'. If it's successful, you can click 'Connect'.

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_jaseci_studio_login.png?raw=true)

Once connected, on the left navigation menu, click on the icon that looks like a graph.

You should see the graph with the root node and app_root node. Click on app_root node, followed by the 'Expand Recursively' button to see the posts node.

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_jaseci_graph.png?raw=true)


## Rebuilding and updating sentinel

Everytime a change is made to the code, you must run the following two commands: 

`jac build main.jac`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_rebuild.png?raw=true)

`sentinel set -snt active:sentinel -mode ir main.jir`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_updating_sentinel.png?raw=true)


## Execute import_news_data walker

This walker:
- deletes the existing post nodes from the graph, if any.
- creates the posts nodes using data from the JSON file.

To run this walker, enter the following command in the jaseci terminal: 

`walker run import_news_data -ctx "{\"file_path\": \"news_posts.json\" }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_execute_import_newsdata.png?raw=true)

You should get a similar result like this: 

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_import_newsdata_result.png?raw=true)


## Updated Graph

Now, let's see the updated graph: 

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_updated_graph_1.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_updated_graph_2.png?raw=true)



## Postman

You can also execute the walkers via Postman.

Download and install the latest version of the [Postman](https://www.postman.com/downloads/) application, based on your Operating System.

Once Postman is running, create a request.

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-1/images/c1_postman_create_request.png?raw=true)

Create a new request:

Select method POST

Enter "http://localhost:8000/js/walker_run" as request URL.

Click on headers tab

Add Authorization as key

Enter "token ***my_token***" [ensure there is 1 space between token and the token you copied]

Copy the JSON Example from the docs under js/walker_run or see below for examples on how to make POST requests.

Under body tab in postman, select raw and change type to JSON

Replace "snt" value with ***my_sentinel_id*** [This can be found in WSL T2]

Ensure you put the walker name.

Send the request

# Sending requests

## walker import_news_data

This walker:
- deletes all the post nodes from the graph.
- creates the posts nodes using data from the JSON file.

``` JSON
{
    "name": "import_news_data",
    "ctx": {"file_path": "./news_posts.json"},
    "_req_ctx": {},
    "snt": "my_sentinel_id",
    "profiling": false,
    "is_async": false
}
```

## walker create_post

``` JSON
{
    "name": "create_post",
    "ctx": {
      "title": "Who will benefit from our oil?",
      "description": "From the publishers desk In July 2019, Kaieteur News conducted an extensive review of 130 oil contracts to better understand the extent to which the Guyana-ExxonMobil deal is fraught with unfair provisions. The findings were alarming. On a daily basis, Kaieteur News will expose these alarming provisions. Today, we start with the provision that speaks ",
      "source": "Kaieteur News",
      "link": "https://www.kaieteurnewsonline.com/2020/09/14/who-will-benefit-from-our-oil/",
      "image": null,
      "published": "2020-09-14 20:11:19.210464",
      "code": "gy"
    },
    "_req_ctx": {},
    "snt": "my_sentinel_id",
    "profiling": false,
    "is_async": false
}
```

## walker update_post

``` JSON
{
    "name": "update_post",
    "nd": "urn:uuid:db0b5d21-1dce-4337-aefd-b64bc028b39f",
    "ctx": {
      "title": "Who will benefit from our oil?",
      "description": "From the publishers desk In July 2019, Kaieteur News conducted an extensive review of 130 oil contracts to better understand the extent to which the Guyana-ExxonMobil deal is fraught with unfair provisions. The findings were alarming. On a daily basis, Kaieteur News will expose these alarming provisions. Today, we start with the provision that speaks ",
      "source": "Kaieteur News",
      "link": "https://www.kaieteurnewsonline.com/2020/09/14/who-will-benefit-from-our-oil/",
      "image": null,
      "published": "2020-09-14 20:11:19.210464",
      "code": "gy"
    },
    "_req_ctx": {},
    "snt": "my_sentinel_id",
    "profiling": false,
    "is_async": false
}
```

## walker delete_post

``` JSON
{
    "name": "delete_post",
    "nd": "urn:uuid:db0b5d21-1dce-4337-aefd-b64bc028b39f",
    "ctx": {},
    "_req_ctx": {},
    "snt": "my_sentinel_id",
    "profiling": false,
    "is_async": false
}
```

## walker get_post

``` JSON
{
    "name": "get_post",
    "nd": "urn:uuid:8e84b373-3815-43c4-bb33-32cb090cf7c3",
    "ctx": {},
    "_req_ctx": {},
    "snt": "my_sentinel_id",
    "profiling": false,
    "is_async": false
}
```

## walker list_posts

``` JSON
{
    "name": "list_posts",
    "ctx": {},
    "_req_ctx": {},
    "snt": "my_sentinel_id",
    "profiling": false,
    "is_async": false
}
```