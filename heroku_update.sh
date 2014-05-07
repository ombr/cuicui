#!/bin/bash
app="$1"
git push git@heroku.com:$app.git cuicui-master:master;
heroku run rake db:migrate -a $app;
heroku restart -a $app
