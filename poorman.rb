require 'rubygems'
require 'mysql'

class PoorMan
  # store list of generated classes in a class instance variable
  class << self; attr_reader :generated_classes; end
  @generated_classes = []

  def initialize(attributes = nil)
    if attributes
      attributes.each_pair do |key, value|
        instance_variable_set('@'+key, value)
      end
    end
  end

  def self.connect(host, user, password, database)
    @@db = Mysql.new(host, user, password, database)

    # go through the list of database tables and create classes for them
    @@db.list_tables.each do |table_name|
      class_name = table_name.split('_').collect { |word| word.capitalize }.join

      # create new class for table with Module#const_set
      @generated_classes << klass = Object.const_set(class_name, Class.new(PoorMan))

      klass.module_eval do
        @@fields = []
        @@table_name = table_name
        def fields; @@fields; end
      end

      # go through the list of table fields and create getters and setters for them
      @@db.list_fields(table_name).fetch_fields.each do |field|
        # add getters and setters
        klass.send :attr_accessor, field.name

        # add field name to list
        klass.module_eval { @@fields << field.name }
      end
    end
  end

  # finds row by id
  def self.find(id)
    result = @@db.query("select * from #{@@table_name} where id = #{id} limit 1")
    attributes = result.fetch_hash
    new(attributes) if attributes
  end

  # finds all rows
  def self.all
    result = @@db.query("select * from #{@@table_name}")
    found = []
    while(attributes = result.fetch_hash) do
      found << new(attributes)
    end
    found
  end
end

# connect PoorMan to your database, it will do the rest of the work for you
PoorMan::connect('localhost', 'root', 'admin', 'test')

# print a list generated classes
p PoorMan::generated_classes

# find user with id:1
user = Lookup.find(1)

# find all users
Lookup.all
