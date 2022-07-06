## DLT with Databricks

In this tutorial, we will create transformations using Delta Live Tables (DLT) in Databricks.
Read the full article [here](https://rxhl.notion.site/dbt-vs-Delta-Live-Tables-42e732a8c4ba450595897eb73832ce95).

![Tables](/assets/zones.png)

### 0. Prereqs

Make sure you have a Databricks account and a cluster up and running.

### 1. Prepare seed data in Databricks

To create some real transformations, we need to provide seed (raw) data to DLT.
We'll manually create a few raw tables in Databricks using scripts available in the `seed` directory.
You can run these scripts directly on a Databricks notebook that is attached to an active cluster.
Note that the seed data can also be created in the form of parquet files.

### 2. Create transformations

a. Open up a Databricks notebook and run the SQL commands found in the `transformations` directory
b. Click on **Workflows** in the sidebar > Delta Live Tables > Create pipeline
c. Select the notebook you just created in the pipeline creation wizard
d. Select **Triggered** for the pipeline mode and hit **Create**
e. Click **Start** on the pipeline window
e. Databricks would now start creating the pipeline, populate your medallion tables, and generate a dependency graph

You can modify the pipeline any time including the schedule and target tables.

## Reference

[DLT quickstart](https://docs.databricks.com/data-engineering/delta-live-tables/delta-live-tables-quickstart.html)
