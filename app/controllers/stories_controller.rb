require 'yaml/store'

class StoriesController < ApplicationController
  def index
    store = YAML::Store.new "stories.store"
    store.transaction do 
      @stories = store[:best]
    end  
  end

  def show
  end
end
