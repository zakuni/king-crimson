"use strict";
import google from 'googleapis';
import React from 'react';
import ReactDOMServer from 'react-dom/server';

(function() {
  var Gantt, OAuth2, debug;
  debug = require('debug')('king-crimson:index');
  OAuth2 = google.auth.OAuth2;
  const SCOPES = ['https://www.googleapis.com/auth/calendar'];

  const clientSecret = process.env.GOOGLE_CLIENT_SECRET;
  const clientId = process.env.GOOGLE_CLIENT_ID;
  const redirectUrl = process.env.GOOGLE_REDIRECT_URL;
  const oauth2Client = new OAuth2(clientId, clientSecret, redirectUrl);

  const authUrl = oauth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES
  });

  Gantt = require('../components/gantt.jsx');

  module.exports = function(app) {

    app.get('/', function(request, response) {
      return response.render('index');
    });

    app.get('/auth/google', function(request, response) {
      return response.redirect(authUrl);
    });

    app.get('/auth/google/callback', function(request, response) {
      var code;
      code = request.query.code;
      return oauth2Client.getToken(code, function(err, token) {
        if (err) {
          debug(err);
          response.send('Error while trying to retrieve access token: ' + err);
          return;
        }
        request.session.token = token;
        return request.session.save(function() {
          return response.redirect('/schedules');
        });
      });
    });

    app.get('/schedules', function(request, response) {
      var calendar;
      if (!request.session.token) {
        return response.redirect('/auth/google');
      } else {
        oauth2Client.credentials = request.session.token;
        calendar = google.calendar('v3');
        return calendar.events.list({
          auth: oauth2Client,
          calendarId: 'primary',
          timeMin: (new Date()).toISOString(),
          maxResults: 10,
          singleEvents: true,
          orderBy: 'startTime'
        }, function(err, res) {
          var events;
          if (err) {
            debug(err);
            return response.redirect('/auth/google');
          } else {
            events = res.items;
            if (events.length === 0) {
              return response.send('No upcoming events found.');
            } else {
              debug(events.type);
              return response.render('table', {
                initialData: events,
                gantt: ReactDOMServer.renderToString(React.createElement(Gantt, {
                  events: events
                }))
              });
            }
          }
        });
      }
    });
  };

}).call(this);
