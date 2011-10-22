require 'lib/event_watcher'

describe "EventWatcher" do
  class Bar  
    def self.my_class_method; "self.class_method" end
    def instance_method; "instance_method"end
  end
  
  describe "method_call_watcher" do
    context "with class method" do
      it "invokes passed block as a proc" do
        passed_object, passed_params, passed_result = ''
        EventWatcher.setup do
          method_call_watcher(:Bar, :my_class_method) do |object, params, result|
            passed_object = object
            passed_params = params
            passed_result = result
          end
        end
        Bar.my_class_method
        passed_object.should == Bar
        passed_params.should == []
        passed_result.should == "self.class_method"
      end
    end

    context "with instance method" do
      it "invokes passed block as a proc" do
        passed_object, passed_params, passed_result = ''
        EventWatcher.setup do
          method_call_watcher(:bar, :instance_method) do |object, params, result|
            passed_object = object
            passed_params = params
            passed_result = result
          end
        end
        Bar.new.instance_method
        passed_object.should be_instance_of Bar
        passed_params.should == []
        passed_result.should == "instance_method"
      end
    end
  end

  describe "callback_watcher" do
    require 'active_record'
    database_path = File.expand_path("../fixtures/test.sqlite3", __FILE__)
    ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => database_path)
    class Foo < ActiveRecord::Base
      after_create :after_create_callback
      def after_create_callback; "after_create_callback" end
    end
    
    it "invokes passed block as a proc" do
      passed_resource = ''
      EventWatcher.setup do
        callback_watcher(:Foo, :after_create) do |resource|
          passed_resource = resource
        end
      end
      Foo.create! :name => "foo"
      passed_resource.should be_instance_of Foo
      passed_resource.name.should == "foo"
    end
  end
end
