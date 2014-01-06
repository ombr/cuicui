#!/bin/bash
heroku apps:delete -a $1
heroku apps:create $1 -r $1 --region eu
heroku addons:add pgbackups:auto-month -r $1
heroku addons:add cloudinary  -r $1
heroku config:set "DOMAIN=$1.herokuapp.com" -r $1
git push $1 `git branch | grep \* | sed -e "s/\* //g"`:master
heroku addons:add newrelic:stark -r $1
heroku addons:add logentries -r $1
heroku run rake db:migrate -r $1
heroku restart -r $1
