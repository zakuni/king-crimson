FROM binarytales/heroku-nodejs:4.3.0

ADD package.json /app/user/
RUN /app/heroku/node/bin/npm install
ADD . /app/user/
