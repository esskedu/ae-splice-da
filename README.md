# Analytics Engineer Solution Set 
## _Dean Abate_

3/6/2023
Total Time Spent: Approx. 2hr

## Write Up
I began working on this Analytics Engineer Problem Set by performing some due dilligence on the dataset as well as working w/ Google Cloud SQL. Some of the first actions I took was to perform a simple select * and look through documentation describing the data. I also looked through the use of the unnesting functions in Google Cloud docs as well as the Stack Overflow link.

I then began working through the first problem. I used a combination of counts and summation to answer questions surrounding aggregation. I didn't have to worry about any possible fanout or duplication of records which could stem from performing calculations on unnested fields, so I only used the main table.

The second problem required unnesting of both the hits and products tables, which I wrote as described per Google Cloud docs. I grouped the count distinct calculation by product category and due to the use of a count distinct I also was able to omit any worries about fanout or duplication.

The thrid problem required a case statement cataloging a record w/o a purchase based on the number of total transactions in the session. I used a concatenation of fullVisitorId and visitId to generate a unique key per session as provided by documentation guidelines. I also used a where clause to only consider records which contained only "Add to Cart" events.

## Question 4 - Building a Dataset
For this dataset, I decided to include a few session totals (numeric), a few traffic source categories, and a few user dimensions to prepare the prediction of a successful transaction.

First, starting with the traffic sources, I felt like it was important to include these dimensions to enable a data scientist to determine if any traffic sources or marketing campaigns are over-indexing in purchase success. This could be important in determining the success of marketing campaigns and test for repeatability w/ any following marketing initiatives. Promotions run on certain sites or "sources" could also indicate over-indexing on ads placed on certain websites. 

Next, I wanted to look at user metrics to enable a data scientist to see if certain geo-ares would be over-indexing in purchase success. Also, I included the type of device a user was using during the session with the intention of checking if certain devices lead to more purchases when normalized. If more purchase success per total sessions occurs on a mobile device rather than a website, it could indicate engineering resource alotment and user growth initiatives. 

Finally, I included some numeric measures w/ the intent for a data scientist to use these in the EDA process or even as features in a regression model. Luckily enough, it appears like the dataset comes preprepared w/ a "sessionQualityDim" field, which seems to be a predictor of purchase success. This "sessionQualityDim" could be used as a benchmark for a data scientists to test their models against but should be removed in the circumstance where colinearity would be a concern. I also included unique_session_id and a binary is_purchase field for use as a success metric in a model.
