# grabbing latest ubuntu image
FROM ubuntu:latest

# setting maintainer
LABEL maintainer="@securitychops"

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y golang-go
RUN apt-get install -y python
RUN apt-get install -y python-pip
RUN apt-get install -y chromium-browser

RUN pip install awscli

RUN go get github.com/michenriksen/aquatone

COPY .start.sh /root/go/bin

WORKDIR /root/go/bin

# autostart our script
CMD ["bash", "/root/go/bin/.start.sh"]
