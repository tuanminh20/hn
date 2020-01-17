require 'yaml/store'

namespace :fetch_stories do
  task :store do
    store = YAML::Store.new "stories.store"
    store.transaction do 
      store[:best] = HackerNews::Engine.best
    end
  end
end
