FROM postgres

ENV POSTGRES_DB movies

ADD ./ml-latest-small.zip /var/lib/ml-latest-small.zip

ADD ./CreateDB.sql /docker-entrypoint-initdb.d/

RUN apt-get update && apt-get install -y unzip

RUN unzip /var/lib/ml-latest-small.zip -d /var/lib
