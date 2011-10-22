require 'lib/event_watcher/watcher'

describe "Watcher" do
  before(:each) do
    class Student < ActiveRecord::Base; end
    @class_method_watcher = EventWatcher::Watcher.build :object_name => "Student", :method_name => "name" do |klass, params, result|
    end

    @instance_method_watcher = EventWatcher::Watcher.build :object_name => "student", :method_name => "name" do |obj, params, result|
    end
  end

  describe "self.build" do
    it "builds a watcher with parameters and a callback block" do
      @class_method_watcher.should be_instance_of EventWatcher::Watcher
    end
  end

  describe "key" do
    it "returns a unique key" do
      @class_method_watcher.key.should == "Student|name"
    end
  end

  describe "klass" do
    context "when watching a class method" do
      it "returns class name constant built  " do
        @class_method_watcher.klass.should == Student
      end
    end

    context "when watching a instance method" do
      it "returns the name constnat of the object's class" do
        @instance_method_watcher.klass.should == Student
      end
    end
  end

  describe "class_method_watcher?" do
    context "when watching a class method" do
      it "returns true" do
        @class_method_watcher.class_method_watcher?.should be_true
      end
    end

    context "when watching a instance method" do
      it "returns false" do
        @instance_method_watcher.class_method_watcher?.should be_false
      end
    end
  end

  describe "self.find" do
    it "returns a matching watcher object by key if it finds one" do
      EventWatcher::Watcher.find(@instance_method_watcher.key).should == @instance_method_watcher
    end

    it "returns nil otherwise" do
      EventWatcher::Watcher.find("nothing").should == nil
    end
  end
end
