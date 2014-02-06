#/bin/bash
for app in `heroku apps | grep ombr-gallerie- | sed -e 's/ombr-gallerie-\([^ ]*\).*/\1/'`; do
  echo ./heroku_update.sh $app
done
