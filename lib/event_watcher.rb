require 'event_watcher/watcher'

module EventWatcher
  class << self
    def method_call_watcher(object_name, method_name, &block)
      watcher = Watcher.build :object_name => object_name, :method_name => method_name, :callback => block
      code = <<-CODE
        alias :old_method :#{watcher.watched_method_name}
        def #{watcher.watched_method_name}(*args)
          result = old_method(*args)
          Watcher.find("#{watcher.key}").trigger_callback(self, args, result) rescue nil
          result
        end
      CODE

      code = "class << self; #{code}; end" if watcher.class_method_watcher?
      watcher.klass.class_eval code
    end

    def callback_watcher(class_name, callback_name, &block)
      watcher = Watcher.build :object_name => class_name, :method_name => callback_name, :callback => block
      watcher.klass.class_eval <<-CODE
        after_create Proc.new {|resource| Watcher.find("#{watcher.key}").trigger_callback(resource) rescue nil }
      CODE
    end

    def register_watchers(&block)
      module_eval &block
    end

    alias :setup :register_watchers
  end
end