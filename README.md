# King Crimson

> 我以外の全ての時間は消し飛ぶッーーーー！

## Development

Make sure you have [Docker Machine](https://docs.docker.com/machine/) and [Docker Compose](https://docs.docker.com/compose/) installed.

```sh
$ git clone git@github.com:zakuni/king-crimson.git # or clone your own fork
$ cd king-crimson
$ docker-machine start dev
$ eval "$(docker-machine env dev)"
$ docker-compose up
```

```sh
$ open "http://$(docker-machine ip dev):3000"
```

### Edit with a normal local workflow
```sh
$ docker-compose run --service-ports shell
```


## Running Locally

```sh
$ heroku docker:start
```

## Deploying to Heroku

```
$ heroku create
$ heroku docker:release
$ heroku config:set GOOGLE_CLIENT_ID=xxxx GOOGLE_CLIENT_SECRET=xxx GOOGLE_REDIRECT_URL=xxx SESSION_SECRET=xxx NODE_ENV=production
$ heroku addons:create heroku-redis
$ heroku open
```

