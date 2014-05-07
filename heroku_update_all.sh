#/bin/bash
for app in `heroku apps | grep "$1" | sed -e "s/\\([^ ]*\\).*/\1/"`; do
#for app in `cat apps`; do
  echo $app
  ./heroku_update.sh $app
done
