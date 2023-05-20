Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands in __*WSL T1*__:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`

# Codelab-5.2

## Summary

* In this codelab we will be building on the ability to extract key entities from natural language search statements and performing a filter based on the extracted search criteria.
* For this we will be walking the graph and narrowing down by any supplied tags and properties of the posts.

## Recording

Here's the recording for codelab-5.2: [Jaseci AI Mentorship Sessions-20230327_153727-Meeting Recording.mp4](https://v75corp-my.sharepoint.com/personal/eldon_marks_v75inc_com/_layouts/15/stream.aspx?id=%2Fpersonal%2Feldon%5Fmarks%5Fv75inc%5Fcom%2FDocuments%2FRecordings%2FJaseci%20AI%20Mentorship%20Sessions%2D20230327%5F153727%2DMeeting%20Recording%2Emp4&ga=1)


## Adding Scripts

Let’s add some scripts to get things up and running a bit quicker…

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.2/images/c5_scripts_folder.png?raw=true)

### Setup 

Let’s add a setup script for all Jaseci setup commands

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.2/images/c5_setup_script.png?raw=true)

### Train 

Let’s add a train script for training up the model

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.2/images/c5_train_script.png?raw=true)

### Rebuild 

Let’s add a rebuild script for when we modify code

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.2/images/c5_rebuild_script.png?raw=true)

### Purge 

Let’s add a purge script for when we need to clear the graph

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.2/images/c5_purge_script.png?raw=true)

## Executing Scripts

We can execute any of the scripts like this:

`script scripts/rebuild`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-5.2/images/c5_executing_scripts.png?raw=true)