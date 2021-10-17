# movie-statistics

Two containers (postgress_db and jupyter_notebook) are deloyed using Docker Compose. A Dockerfile is used to 
build the database container. It adds and unzips the database file (.zip). When the database container is running,
CreateDB.sql is executed. It transforms and loads the data into 4 tables. Meanwhile movie_stats.ipynb is added to 
the Jupyter container. The notebook connects to the database using an adapter and provides a few statistics.

The dataset (ml-latest-small.zip) was accesed from https://grouplens.org/datasets/movielens/latest/
