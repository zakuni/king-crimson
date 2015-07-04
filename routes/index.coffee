fs         = require 'fs'
readline   = require 'readline'
google     = require 'googleapis'
googleAuth = require 'google-auth-library'

SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']
TOKEN_DIR = (process.env.HOME || process.env.HOMEPATH ||
    process.env.USERPROFILE) + '/.credentials/'
TOKEN_PATH = TOKEN_DIR + 'calendar-api-quickstart.json'

fs.readFile 'client_secret.json', processClientSecrets = (err, content) =>
  if (err)
    console.log('Error loading client secret file: ' + err)
    return
  # Authorize a client with the loaded credentials, then call the
  # Google Calendar API.
  credentials = JSON.parse(content)
  clientSecret = credentials.web.client_secret
  clientId = credentials.web.client_id
  redirectUrl = credentials.web.redirect_uris[0]
  redirectUrl = "http://localhost:5000/auth/google/callback"
  auth = new googleAuth()
  @oauth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl)

  @authUrl = @oauth2Client.generateAuthUrl
    access_type: 'offline'
    scope: SCOPES


module.exports = (app) =>

  app.get '/', (request, response) ->
    # Load client secrets from a local file.
    response.send('『結果』だけだ！！この世には『結果』だけが残る！！')


  app.get '/auth/google', (request, response) =>
    response.redirect @authUrl

    ###
     Store token to disk be used in later program executions.

     @param {Object} token The token to store to disk.
    ###
    storeToken = (token) ->
      try
        fs.mkdirSync(TOKEN_DIR)
      catch err
        if (err.code != 'EEXIST')
          throw err
      fs.writeFile(TOKEN_PATH, JSON.stringify(token))
      console.log('Token stored to ' + TOKEN_PATH)


  app.get '/auth/google/callback', (request, response) =>
    code = request.query.code
    @oauth2Client.getToken code, (err, token) =>
      if err
        console.log('Error while trying to retrieve access token', err)
        return
      @oauth2Client.credentials = token

      calendar = google.calendar('v3')
      calendar.events.list
        auth: @oauth2Client,
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
