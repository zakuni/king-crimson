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

## Running Locally

```sh
$ heroku docker:start
```

## Deploying to Heroku

```
$ heroku create
$ heroku docker:release
$ heroku open
```

