class Enum
  
  attr_accessor :def_name, :value, :name
  
  def initialize(def_name, value, name)
    @def_name, @value, @name = def_name, value, name
  end
  
  def self.define(*args)
    register(new(*args))
  end
  
  def self.register(instance)
    @@instances_map ||= {}
    @@instances_map[self.to_s] ||= []
    @@instances_map[self.to_s] << instance
    self.class_eval <<-CODE
      def self.#{instance.def_name}
        def_name_of("#{instance.def_name}")
      end
    CODE
  end
  
  def self.to_a
    @@instances_map[self.to_s]
  end
  
  #additional_attr
  def self.additional_attr(*attrs)
    self.class_eval <<-CODE
      attr_accessor #{attrs.collect{|e|":#{e.to_s}"}.join(",")}
      def initialize(def_name, value, name, #{attrs.collect{|e|e.to_s}.join(",")})
        super(def_name, value, name)
        #{attrs.collect{|e|"@#{e.to_s} = #{e.to_s}"}.join(";")}
      end
    CODE
  end
  
  #Enumerable
  extend Enumerable
  
  def self.each
    self.to_a.each do |instance|
      yield instance
    end
  end
  
  def self.def_name_of(def_name)
    self.detect{|e|e.def_name.to_s == def_name.to_s}
  end
  
  def self.value_of(value)
    self.detect{|e|e.value.to_s == value.to_s}
  end
  
  def self.name_of(name)
    self.detect{|e|e.name.to_s == name.to_s}
  end
  
  def self.def_names
    self.collect{|e|e.def_name}
  end
  
  def self.values
    self.collect{|e|e.value}
  end
  
  def self.names
    self.collect{|e|e.name}
  end
  
end