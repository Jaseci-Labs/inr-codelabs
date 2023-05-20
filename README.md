Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands in __*WSL T1*__:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`

# Codelab-3

## Summary

* The graph will be extended to accommodate user-defined content tags with related training statements. 
* Additional CRUD-based walkers will be added to allow the tags to be managed. 
* A zero-shot text-classification model will be leveraged by a specially created walker to walk the graph of news posts, classify their titles against the statements of each tag and finally ascribe tags (via edges) which apply. 


## Recording

Here's the recording for codelab-3: [Jaseci AI Mentorship Sessions-20230308_153621-Meeting Recording.mp4](https://v75corp-my.sharepoint.com/personal/eldon_marks_v75inc_com/_layouts/15/stream.aspx?id=%2Fpersonal%2Feldon%5Fmarks%5Fv75inc%5Fcom%2FDocuments%2FRecordings%2FJaseci%20AI%20Mentorship%20Sessions%2D20230308%5F153621%2DMeeting%20Recording%2Emp4&ga=1)


## Load the use_enc module

`actions load module jac_nlp.use_enc`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-3/images/c3_load_use_enc.png?raw=true)


## Load the tag data

`walker run import_tag_data -ctx "{\"file_path\": \"tag_data.json\" }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-3/images/c3_load_tag_data.png?raw=true)


## Build and update

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-3/images/c3_build.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-3/images/c3_update_sentinel.png?raw=true)


## Execute tag_posts

`walker run tag_posts`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-3/images/c3_execute_tag_posts.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-3/images/c3_tag_posts_results.png?raw=true)


## Check out the updated Graph

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-3/images/c3_updated_graph.png?raw=true)