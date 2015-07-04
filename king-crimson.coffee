express    = require 'express'
mongoose   = require 'mongoose'

app = express()

require('./routes')(app)

app.use(express.static(__dirname + '/public'))

mongoose.connect('mongodb://db/king-crimson')
db = mongoose.connection;
db.on 'error', console.error.bind(console, 'connection error:')

module.exports = app
