# King Crimson

## Running Locally

Make sure you have [Node.js](http://nodejs.org/) and the [Heroku Toolbelt](https://toolbelt.heroku.com/) installed.

```sh
$ git clone git@github.com:zakuni/king-crimson.git # or clone your own fork
$ cd king-crimson
$ docker-machine start dev
$ eval "$(docker-machine env dev)"
$ heroku docker:start
```

Your app should now be running on [localhost:5000](http://localhost:5000/).

## Deploying to Heroku

```
$ heroku create
$ heroku docker:release
$ heroku open
```

