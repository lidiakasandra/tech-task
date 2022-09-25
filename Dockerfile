FROM node:latest
WORKDIR /usr/src/

RUN git clone https://github.com/lidiakasandra/tech-task.git

WORKDIR /usr/src/tech-task/app
RUN npm install 

ARG application_port=8080
ENV PORT=$application_port

EXPOSE $application_port

CMD [ "npm", "start" ]