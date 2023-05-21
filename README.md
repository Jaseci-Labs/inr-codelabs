Before you begin running any JAC program, always remember to install or update your current version of jaseci. You can do this by running the following commands in __*WSL T1*__:

`pip3 install jaseci` or `pip3 install jaseci --upgrade`

`pip3 install jaseci-serv` or `pip3 install jaseci-serv --upgrade`

# Codelab-6

## Summary

* In this codelab we will be implementing some semantic clustering techniques to automatically generate associations among related posts.
* For this we will be leveraging the embeddings of the post summaries, the UMAP dimensionality reduction algorithm and two clustering approaches, namely, HDBScan and KMeans.

## Recording

Here's the recording for codelab-6: [Jaseci AI Mentorship Sessions-20230412_160903-Meeting Recording.mp4](https://v75corp-my.sharepoint.com/personal/eldon_marks_v75inc_com/_layouts/15/stream.aspx?id=%2Fpersonal%2Feldon%5Fmarks%5Fv75inc%5Fcom%2FDocuments%2FRecordings%2FJaseci%20AI%20Mentorship%20Sessions%2D20230412%5F160903%2DMeeting%20Recording%2Emp4&ga=1)


## Install modules

Let’s add the modules we’ll need to do the clustering

`pip install jac_misc[cluster]`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-6/images/c6_install_cluster_module.png?raw=true)


## Build and update

`script scripts/rebuild`

![alt text](https://github.com/Jaseci-Labs/inr-codelabs/blob/codelab-6/images/c6_build_update.png?raw=true)