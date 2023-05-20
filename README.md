Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands in __*WSL T1*__:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`

# Codelab-4

## Summary

* In this codelab we will be building the ability for users to ask questions related to content and get results, e.g. “What’s been happening with the war in Ukraine?”
* For this we will be employing the USE_QA pre-trained model run against the post summaries.

## Recording

Here's the recording for codelab-4: [Jaseci AI Mentorship Sessions-20230313_113346-Meeting Recording.mp4](https://v75corp-my.sharepoint.com/personal/eldon_marks_v75inc_com/_layouts/15/stream.aspx?id=%2Fpersonal%2Feldon%5Fmarks%5Fv75inc%5Fcom%2FDocuments%2FRecordings%2FJaseci%20AI%20Mentorship%20Sessions%2D20230313%5F113346%2DMeeting%20Recording%2Emp4&ga=1)


## Load the use_qa module

`actions load module jac_nlp.use_qa`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_load_use_qa.png?raw=true)


## Build and update

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_build.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_update_sentinel.png?raw=true)


## Execute semantic_search

`walker run semantic_search -ctx "{\"query\": \"What is the latest in the oil and gas industry in Guyana?\" }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_execute_semantics_search_1.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_semantics_search_result_1.png?raw=true)


`walker run semantic_search -ctx "{\"query\": \Show me all reports of shootings\" }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_execute_semantics_search_2.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_semantics_search_result_2.png?raw=true)


`walker run semantic_search -ctx "{\"query\": \"Any court cases?\" }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_execute_semantics_search_3.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-4/images/c4_semantics_search_result_3.png?raw=true)