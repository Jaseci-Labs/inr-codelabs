Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands in __*WSL T1*__:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`

## Recording

Here's the recording for codelab-2.1: [Jaseci AI Mentorship Sessions-20230301_113218-Meeting Recording.mp4](https://v75corp-my.sharepoint.com/personal/eldon_marks_v75inc_com/_layouts/15/stream.aspx?id=%2Fpersonal%2Feldon%5Fmarks%5Fv75inc%5Fcom%2FDocuments%2FRecordings%2FJaseci%20AI%20Mentorship%20Sessions%2D20230301%5F113218%2DMeeting%20Recording%2Emp4&ga=1)


You'll also need to install the jac_nlp module:

`pip install jac_nlp[t5_sum]`

If you encountered an error while trying to install package - sentencepiece, then run the following 3 commands:

`sudo apt-get install pkg-config`

`sudo apt-get install cmake`

`pip install sentencepiece`

Now, try running `pip install jac_nlp[t5_sum]` again.

Next, run the following 2 commands to create mydatabase file. This is only necessary if the mydatabase file is not already in the current folder.

`jsserv makemigrations base`

`jsserv migrate`

Now, we will start the server on port 8000:

`jsserv runserver 0.0.0.0:8000`

Go to localhost:8000/docs/

You should be able to see Jaseci API Docs


Open another WSL terminal. We'll refer to this as __*WSL T2*__.

In __*WSL T2*__:

First, we'll need to create a superuser

`jsserv createsuperuser`

Enter email

Enter password (twice)

Then, login to localhost.

`jsctl -m`

`login http://localhost:8000`

Enter username and password of superuser created above.
If login successful, a token should be generated. We'll refer to this as ***my_token***.

After logging in, we'll need to load the jac_nlp module

`actions load module jac_nlp.t5_sum`

Then, load the custom action we created.

`actions load local inr_actions.py`

This might take a while, especially if you're running it for the first time.

Open another WSL terminal. We'll refer to this as __*WSL T3*__.

In __*WSL T3*__:

`jsctl jac build main.jac`

Note: You must run this command, every time a change is made to your code.


In __*WSL T2*__:

`sentinel register -name main -mode ir main.jir`

`alias list`

We'll refer to the active:sentinel as ***my_sentinel_id***


If you have already registered the sentinel, then just run:

`sentinel set -snt active:sentinel -mode ir main.jir`

You'll need to run this command after you build.


## In postman

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