CREATE TABLE IF NOT EXISTS movies (
   movie_id INT NOT NULL PRIMARY KEY,
   movie_title VARCHAR(255) NOT NULL,
   release_year INT 
);

CREATE TABLE IF NOT EXISTS movie_genres (
   movie_id INT NOT NULL REFERENCES movies,
   genre VARCHAR(500) NOT NULL,
   PRIMARY KEY (movie_id, genre)
);

CREATE TABLE IF NOT EXISTS movie_ratings (
   user_id INT NOT NULL,
   movie_id INT NOT NULL REFERENCES movies,
   rating REAL NOT NULL,
   date TIMESTAMP,
   PRIMARY KEY (user_id, movie_id)
);

CREATE TABLE IF NOT EXISTS movie_tags (
   user_id INT NOT NULL,
   movie_id INT NOT NULL REFERENCES movies,
   tag VARCHAR(255) NOT NULL,
   date TIMESTAMP,
   PRIMARY KEY (user_id, movie_id, tag)
);

CREATE TABLE IF NOT EXISTS movies_staging (
   movie_id INT NOT NULL,
   movie_title VARCHAR(255) NOT NULL,
   movie_genre VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS movie_ratings_staging (
   user_id INT NOT NULL,
   movie_id INT NOT NULL,
   rating REAL NOT NULL,
   date NUMERIC
);

CREATE TABLE IF NOT EXISTS movie_tags_staging (
   user_id INT NOT NULL,
   movie_id INT NOT NULL,
   tag VARCHAR(255) NOT NULL,
   date NUMERIC
);

COPY movies_staging FROM '/var/lib/ml-latest-small/movies.csv' DELIMITER ',' CSV HEADER ;

INSERT INTO movies
SELECT movie_id, regexp_replace(movie_title, ' [(](.*)[)]', ''), substring(movie_title from ' [(]([0-9]{4})[)]')::int
FROM movies_staging;

INSERT INTO movie_genres
SELECT movie_id, unnest(string_to_array(movie_genre, '|')) as "movie_genre"
FROM movies_staging;

COPY movie_ratings_staging FROM '/var/lib/ml-latest-small/ratings.csv' DELIMITER ',' CSV HEADER ;

INSERT INTO movie_ratings
SELECT user_id, movie_id, rating, to_timestamp(date)
FROM movie_ratings_staging;

COPY movie_tags_staging FROM '/var/lib/ml-latest-small/tags.csv' DELIMITER ',' CSV HEADER ;

INSERT INTO movie_tags
SELECT user_id, movie_id, tag, to_timestamp(date)
FROM movie_tags_staging;

DROP TABLE movies_staging;
DROP TABLE movie_tags_staging;
DROP TABLE movie_ratings_staging;

