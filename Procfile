web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: env QUEUE=* TERM_CHILD=1 bundle exec rake environment resque:work
worker_convert: env QUEUE=convert TERM_CHILD=1 bundle exec rake environment resque:work
