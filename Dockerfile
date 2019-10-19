FROM golang:alpine

# setting maintainer
LABEL maintainer="@securitychops"

# using non root user
RUN addgroup -S bender && \
    adduser -S bender -G bender

# get startup script ready
COPY .start.sh /home/bender

    # make startup script executable
RUN chmod +x /home/bender/.start.sh && \
    # install the basics
    apk add --update \
    git \
    chromium \
    python \
    py-pip && \
    # get aws
    pip install awscli && \
    # get aquatone
    go get github.com/michenriksen/aquatone && \
    # dont need git anymore, kill it
    apk del git

# we are now bender
USER bender
WORKDIR /home/bender

# autostart our script
CMD ["sh", ".start.sh"]
