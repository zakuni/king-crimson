module.exports = {
  entry: './components/client.cjsx',
  output: {
    filename: './public/js/bundle.js'
  },
  module: {
    loaders: [
      {test: /\.cjsx$/, loaders: ['coffee', 'cjsx']},
      {
        test: /\.jsx?$/,
        exclude: /(node_modules|bower_components)/,
        loader: 'babel',
        query: {
          presets: ['es2015', 'react']
        }
      }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.jsx', '.cjsx', '.coffee']
  }
};
