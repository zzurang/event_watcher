require "rubygems"
require "active_record"

module EventWatcher
  class Watcher
    include ActiveSupport::Inflector
    attr_accessor :watched_method_name
    alias :watched_callback_name :watched_method_name
    
    @@watchers = {}
    def self.find(key)
      @@watchers[key]
    end

    def initialize(attributes)
      @watched_object_name = attributes[:object_name].to_s
      @watched_method_name = attributes[:method_name].to_s
      @callback = attributes[:callback]
    end

    def key
      "#{@watched_object_name}|#{@watched_method_name}"
    end

    def self.build(attributes)
      watcher = Watcher.new(attributes)
      @@watchers[watcher.key] = watcher
    end

    def trigger_callback(*args)
      @callback.call(*args)
    end

    def class_method_watcher?
      @watched_object_name.camelize == @watched_object_name
    end

    def klass
      @watched_object_name.camelize.constantize
    end
  end
end