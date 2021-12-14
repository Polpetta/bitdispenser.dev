FROM fleek/hugo:node-16

LABEL MAINTAINER="Davide Polonio poloniodavide@gmail.com"
LABEL DESCRIPTION="Docker image for deploying website on IPFS via fleek"

RUN apt-get update \
 && apt-get install -y git-lfs \
 && rm -rf /var/lib/apt/lists/*