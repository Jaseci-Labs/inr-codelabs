Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands in __*WSL T1*__:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`

# Codelab-5.1

## Summary

* In this codelab we will be building the ability for users to ask questions with criteria for more specific search results, e.g. "Can you give me the \[latest\](timestamp) \[national\](tag) news from the \[Guyana Chronicle\](news_source)?"
* For this we will be employing the TFM_NER model to perform entity extraction.

## Recording

Here's the recording for codelab-5.1: [Jaseci AI Mentorship Sessions-20230320_153331-Meeting Recording.mp4](https://v75corp-my.sharepoint.com/personal/eldon_marks_v75inc_com/_layouts/15/stream.aspx?id=%2Fpersonal%2Feldon%5Fmarks%5Fv75inc%5Fcom%2FDocuments%2FRecordings%2FJaseci%20AI%20Mentorship%20Sessions%2D20230320%5F153331%2DMeeting%20Recording%2Emp4&ga=1)

In this codelab, we have added an ai folder for ai model stuff

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_ai_folder.png?raw=true)

We have also added a tfm_ner module to help with training, and a data folder for training data

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_tfm_ner.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_data_folder.png?raw=true)


## Load the tfm_ner module

`actions load module jac_nlp.tfm_ner`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_load_tfm_ner.png?raw=true)


## Build and update

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_build.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_update_sentinel.png?raw=true)


## Train the model (this will take some time…)

`walker run tfm_ner_train_model`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_tfm_ner_train_model.png?raw=true)

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_tfm_ner_train_model_result.png?raw=true)


## Save and load the trained model

`walker run tfm_ner_save_model`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_tfm_ner_save_model.png?raw=true)

`walker run tfm_ner_load_model`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_tfm_ner_load_model.png?raw=true)


## Execute entity_search

`walker run entity_search -ctx "{\"utterance\": \"What are the news reports on crime and business from Chronicle news\" }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_execute_entity_search_1.png?raw=true)

`walker run entity_search -ctx "{\"utterance\": \"What happened on May 14 regarding politics and business in Guyana fron CNN World news\" }"`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.1/images/c5_execute_entity_search_2.png?raw=true)