express = require 'express'
mongoose = require('mongoose')

app = express()

app.use(express.static(__dirname + '/public'))

app.get '/', (request, response) ->
  response.send('『結果』だけだ！！この世には『結果』だけが残る！！')


mongoose.connect('mongodb://db/king-crimson')
db = mongoose.connection;
db.on 'error', console.error.bind(console, 'connection error:')

module.exports = app
