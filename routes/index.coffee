fs         = require 'fs'
google     = require 'googleapis'
googleAuth = require 'google-auth-library'

SCOPES = ['https://www.googleapis.com/auth/calendar']

clientSecret = process.env.GOOGLE_CLIENT_SECRET
clientId     = process.env.GOOGLE_CLIENT_ID
redirectUrl  = process.env.GOOGLE_REDIRECT_URL
auth = new googleAuth()
oauth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl)

authUrl = oauth2Client.generateAuthUrl
  access_type: 'offline'
  scope: SCOPES


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
      response.redirect '/tasks'

  app.get '/tasks', (request, response) ->
    if request.session.token
      oauth2Client.credentials = request.session.token
    else
      response.redirect '/auth/google'
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
        response.send 'The API returned an error: ' + err
      events = res.items
      if events.length == 0
        response.send 'No upcoming events found.'
      else
        for event in events
          start = event.start.dateTime || event.start.date
          console.log('%s - %s', start, event.summary)
        response.send events
