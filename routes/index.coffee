module.exports = (app) ->
  app.get '/', (request, response) ->
    response.send('『結果』だけだ！！この世には『結果』だけが残る！！')
