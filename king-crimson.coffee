express = require 'express'

app = express()

app.use(express.static(__dirname + '/public'))

app.get '/', (request, response) ->
  response.send('『結果』だけだ！！この世には『結果』だけが残る！！')

module.exports = app
