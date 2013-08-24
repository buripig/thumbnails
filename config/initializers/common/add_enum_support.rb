ActiveRecord::Base.class_eval do
  def self.enum(attr, enum_class)
    self.class_eval <<-CODE
      def #{attr}_name
        #{enum_class}.value_of(self.#{attr}).name rescue nil
      end
      def #{attr}_as_enum
        #{enum_class}.value_of(self.#{attr}) rescue nil
      end
    CODE
  end
end