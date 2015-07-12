express    = require 'express'
session    = require 'express-session'
RedisStore = require('connect-redis')(session)
mongoose   = require 'mongoose'
redis      = require 'redis'
url        = require 'url'

app = express()

app.use(express.static(__dirname + '/public'))
app.set('view engine', 'jade')

redisURL = url.parse(process.env.REDIS_URL)
redisHost = redisURL.hostname or 'redis'
redisPort = redisURL.port or '6379'

app.use session
  store: new RedisStore({host: redisHost, port: redisPort})
  secret: process.env.SESSION_SECRET
  resave: false
  saveUninitialized: false

require('./routes')(app)

mongoose.connect('mongodb://db/king-crimson')
db = mongoose.connection;
db.on 'error', console.error.bind(console, 'connection error:')

module.exports = app
