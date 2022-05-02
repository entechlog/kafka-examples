# Dockerfile
FROM python:3.9-slim-buster

# Install Java
COPY --from=openjdk:8-jre-slim /usr/local/openjdk-8 /usr/local/openjdk-8
ENV JAVA_HOME /usr/local/openjdk-8
RUN update-alternatives --install /usr/bin/java java /usr/local/openjdk-8/bin/java 1

WORKDIR /usr/app

# Install sbt
RUN apt-get update
RUN apt-get install apt-transport-https curl gnupg -yqq
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import
RUN chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg
RUN apt-get update
RUN apt-get --assume-yes install sbt

# Install Docker
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy curl docker.io && \
    curl -sSL https://get.docker.com/ | sh

# Install remora
RUN apt-get --assume-yes install git 
RUN git clone https://github.com/zalando-incubator/remora.git
WORKDIR remora
#RUN sbt docker:publishLocal
