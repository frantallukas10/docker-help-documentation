# getting base image alpine
FROM alpine

LABEL version="0.0.0"

EXPOSE 3000

CMD ["sudo apt install yarn", "RUN apk add --update nodejs nodejs-npm", "RUN mkdir app"]
WORKDIR "./app"


