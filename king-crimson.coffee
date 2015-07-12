express    = require 'express'
session    = require 'express-session'
RedisStore = require('connect-redis')(session)
mongoose   = require 'mongoose'
redis      = require 'redis'

app = express()

app.use(express.static(__dirname + '/public'))
app.set('view engine', 'jade')

app.use session
  store: new RedisStore({host: 'redis', port: 6379})
  secret: process.env.SESSION_SECRET

require('./routes')(app)

mongoose.connect('mongodb://db/king-crimson')
db = mongoose.connection;
db.on 'error', console.error.bind(console, 'connection error:')

module.exports = app
