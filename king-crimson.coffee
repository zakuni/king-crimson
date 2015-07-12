express    = require 'express'
session    = require 'express-session'
RedisStore = require('connect-redis')(session)
mongoose   = require 'mongoose'
redis      = require 'redis'
url        = require 'url'

app = express()

app.use(express.static(__dirname + '/public'))
app.set('view engine', 'jade')

redisURL = url.parse(process.env.REDIS_URL) if process.env.REDIS_URL
redisHost = if redisURL then redisURL.hostname else 'redis'
redisPort = if redisURL then redisURL.port else '6379'

sess =
  store: new RedisStore
    host: redisHost
    port: redisPort
  secret: process.env.SESSION_SECRET
  resave: false
  saveUninitialized: false
  cookie: {}

if process.env.NODE_ENV is "production"
  sess.cookie.secure = true

app.use session(sess)

require('./routes')(app)

mongoose.connect('mongodb://db/king-crimson')
db = mongoose.connection;
db.on 'error', console.error.bind(console, 'connection error:')

module.exports = app
