## EventWatcher
http://github.com/zzurang/event_watcher

## DESCRIPTION
Simple DSL for monitoring class_methods, instance_methods and hooks calling history 


```ruby
  class Subscriber < ActiveRecord::Base
    after_create :foo
  end

  EventWatcher.setup do  
    #watching a hook method
    callback_watcher(:Subscriber, :after_create) do |created_resource|
      puts "after_create hook has been called !"
    end

    #watching a class method
    method_call_watcher(:Subscriber, :create) do |klass, params, result|    
      puts "class method 'Subscriber.create' has been called"      
    end

    #watching an instance method
    method_call_watcher(:subscriber, :destroy) do |object, params, result|
      puts "instance method 'destroy' has been called on a Subscriber object"
    end
  end

  subscriber = Subscriber.create :name => "foo"
  subscriber.destroy

  # OUTPUT
  #   after_create hook has been called !
  #   class method 'Subscriber.create' has been called
  #   instance method 'destroy' has been called on a Subscriber object
```
## INSTALL
  gem install event_watcher
