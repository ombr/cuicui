#!/bin/bash
app="ombr-gallerie-$1"
heroku maintenance:on -a "$app"
heroku config:set SEGMENT_IO=di7lgdee45 INTERCOM=fb88bf1867315b40cae21a48af07d1cfb10e6d61 INTERCOM_SECRET=ff2897927a25a84c42a0579fb1e610b6eae58f8a -a "$app"
git push git@heroku.com:$app.git cuicui-master:master
heroku run rake db:migrate -a "$app"
heroku maintenance:off -a "$app"
