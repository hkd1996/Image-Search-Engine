# Image-Search-Engine
Offline image search engine to search relevant to the input query image using mean as the image descriptor

# Description:
 'Search.R' is the code to search the relevant image from the dataset. 
 Once the above program is executed it asks for the user to input the query image. Then it calculates the mean of the query image and generates 'query_avg.csv'. Then the mean of all the images of the dataset is calculated and stored in 'avg.csv'
 Then "Cosine Similarity" is used as the metric to find similarity between images. 5 most relevant images are retreived and displayed
 Makefile to clear all previous contents of the file
 
 #Dataset link
 http://lear.inrialpes.fr/people/jegou/data.php
