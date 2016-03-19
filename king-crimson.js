(function(){
  "use strict";
  const express = require('express');
  const session = require('express-session');
  const RedisStore = require('connect-redis')(session);
  const mongoose = require('mongoose');
  const redis = require('redis');
  const url = require('url');

  const app = express();

  app.use(express["static"](__dirname + '/public'));
  app.set('view engine', 'jade');

  let redisURL;
  if (process.env.REDIS_URL) {
    redisURL = url.parse(process.env.REDIS_URL);
  }
  const redisHost = redisURL ? redisURL.hostname : 'redis';
  const redisPort = redisURL ? redisURL.port : '6379';
  const redisClient = redis.createClient(redisPort, redisHost);

  if (redisURL) {
    redisClient.auth(redisURL.auth.split(":")[1]);
  }

  const sess = {
    store: new RedisStore({
      client: redisClient
    }),
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: {
      maxAge: 60 * 60 * 24 * 1000
    }
  };

  if (process.env.NODE_ENV === "production") {
    app.enable('trust proxy');
    sess.cookie.secure = true;
  }

  app.use(session(sess));

  require('./routes')(app);

  mongoose.connect('mongodb://db/king-crimson');
  const db = mongoose.connection;
  db.on('error', console.error.bind(console, 'connection error:'));

  module.exports = app;
})();
