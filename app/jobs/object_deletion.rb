# ObjectDeletion
class ObjectDeletion
  # require 'heroku_resque_auto_scale.rb'
  # extend HerokuAutoScaler::AutoScaling if Rails.env.production?

  @queue = :delete
  def self.perform(model, id)
    clazz = model.constantize
    clazz.find(id).destroy
  end
end
