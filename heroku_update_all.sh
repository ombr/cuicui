#/bin/bash
for app in `heroku apps | grep "$1" | sed -e "s/\\([^ ]*\\).*/\1/"`; do
  echo $app
  ./heroku_update.sh $app
done
