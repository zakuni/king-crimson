debug      = require('debug')('king-crimson:index')
fs         = require 'fs'
google     = require 'googleapis'
React = require 'react'

OAuth2 = google.auth.OAuth2
SCOPES = ['https://www.googleapis.com/auth/calendar']

clientSecret = process.env.GOOGLE_CLIENT_SECRET
clientId     = process.env.GOOGLE_CLIENT_ID
redirectUrl  = process.env.GOOGLE_REDIRECT_URL
oauth2Client = new OAuth2(clientId, clientSecret, redirectUrl)

authUrl = oauth2Client.generateAuthUrl
  access_type: 'offline'
  scope: SCOPES

require('coffee-react/register')
TableApp = require('../components/table.cjsx')

module.exports = (app) ->

  app.get '/', (request, response) ->
    response.render('index')


  app.get '/auth/google', (request, response) ->
    response.redirect authUrl

  app.get '/auth/google/callback', (request, response) ->
    code = request.query.code
    oauth2Client.getToken code, (err, token) ->
      if err
        response.send 'Error while trying to retrieve access token: ' + err
        return
      request.session.token = token
      request.session.save ->
        response.redirect '/tasks'

  app.get '/tasks', (request, response) ->
    unless request.session.token
      response.redirect '/auth/google'
    else
      oauth2Client.credentials = request.session.token
      calendar = google.calendar('v3')
      calendar.events.list
        auth: oauth2Client,
        calendarId: 'primary',
        timeMin: (new Date()).toISOString(),
        maxResults: 10,
        singleEvents: true,
        orderBy: 'startTime'
      , (err, res) ->
        if err
          debug err
          response.redirect '/auth/google'
        else
          events = res.items
          if events.length == 0
            response.send 'No upcoming events found.'
          else
            debug events.type
            response.render('table', {
              events: events
              table: React.renderToString(
                React.createElement(TableApp, {events: events})
              )
            })
