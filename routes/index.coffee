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


###
 Create an OAuth2 client with the given credentials, and then execute the
 given callback function.

 @param {Object} credentials The authorization client credentials.
 @param {function} callback The callback to call with the authorized client.
###
authorize = (credentials, callback) =>
  clientSecret = credentials.web.client_secret
  clientId = credentials.web.client_id
  redirectUrl = credentials.web.redirect_uris[0]
  redirectUrl = "http://localhost:5000/auth/google/callback"
  auth = new googleAuth()
  @oauth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl)

module.exports = (app) =>
  app.get '/', (request, response) ->
    # Load client secrets from a local file.
    response.send('『結果』だけだ！！この世には『結果』だけが残る！！')

  app.get '/auth/google', (request, response) =>
    response.redirect @authUrl

    ###
     Get and store new token after prompting for user authorization, and then
     execute the given callback with the authorized OAuth2 client.

     @param {google.auth.OAuth2} oauth2Client The OAuth2 client to get token for.
     @param {getEventsCallback} callback The callback to call with the authorized
         client.
    ###
    getNewToken = (oauth2Client, callback) ->
      response.redirect authUrl
      # rl = readline.createInterface
      #   input: process.stdin
      #   output: process.stdout

      # rl.question 'Enter the code from that page here: ', (code) ->
      #   rl.close()
      #   oauth2Client.getToken code, (err, token) ->
      #     if err
      #       console.log('Error while trying to retrieve access token', err)
      #       return
      #     oauth2Client.credentials = token
      #     storeToken(token)
      #     callback(oauth2Client)

      # oauth2Client.getToken "xxxxxxxxxxxxxxxx", (err, token) ->
      #   if err
      #     console.log('Error while trying to retrieve access token', err)
      #     return
      #   oauth2Client.credentials = token
      #   storeToken(token)
      #   callback(oauth2Client)



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
      # storeToken(token)
      # callback(oauth2Client)
    # response.send(listEvents(@oauth2Client))

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
          # console.log('Upcoming 10 events:')
          for event in events
            start = event.start.dateTime || event.start.date
            console.log('%s - %s', start, event.summary)
          response.send events

    ###
     Lists the next 10 events on the user's primary calendar.

     @param {google.auth.OAuth2} auth An authorized OAuth2 client.
    ###
    listEvents = (auth) ->
      calendar = google.calendar('v3')
      calendar.events.list
        auth: auth,
        calendarId: 'primary',
        timeMin: (new Date()).toISOString(),
        maxResults: 10,
        singleEvents: true,
        orderBy: 'startTime'
      , (err, response) ->
        if err
          return 'The API returned an error: ' + err
        events = response.items
        if events.length == 0
          return 'No upcoming events found.'
        else
          # console.log('Upcoming 10 events:')
          for event in events
            start = event.start.dateTime || event.start.date
            console.log('%s - %s', start, event.summary)
