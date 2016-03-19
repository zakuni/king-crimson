# King Crimson

> 我以外の全ての時間は消し飛ぶッーーーー！

## Clone Project

```sh
git clone git@github.com:zakuni/king-crimson.git # or clone your own fork
cd king-crimson
touch .env # and modify as .env_sample
```

## Development

Make sure you have [Docker Machine](https://docs.docker.com/machine/) and [Docker Compose](https://docs.docker.com/compose/) installed.

```sh
cd king-crimson
docker-machine start dev
eval "$(docker-machine env dev)"
docker-compose up
```

```sh
open "http://$(docker-machine ip dev):3000"
```

### Edit with a normal local workflow

```sh
docker-compose run --service-ports shell #instead of deocker-compose up
# and then, do npm start or npm run start-dev or whatever...
```

## Deploying to Heroku

```sh
heroku create
heroku docker:release
heroku config:set GOOGLE_CLIENT_ID=xxxx GOOGLE_CLIENT_SECRET=xxx GOOGLE_REDIRECT_URL=xxx SESSION_SECRET=xxx NODE_ENV=production
heroku addons:create heroku-redis
heroku open
```
