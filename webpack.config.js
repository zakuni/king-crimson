module.exports = {
  entry: './components/client.cjsx',
  output: {
    filename: './public/js/bundle.js'
  },
  module: {
    loaders: [
      {test: /\.cjsx$/, loaders: ['coffee', 'cjsx']}
    ]
  },
  resolve: {
    extensions: ['', '.js', '.cjsx', '.coffee']
  }
};
