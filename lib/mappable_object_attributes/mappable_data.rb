module MappableObjectAttributes; 
  module MappableData 
    extend ActiveSupport::Concern

    included do
      class_attribute :data_attributes_map
      self.data_attributes_map ||= DataAttributesMap.new
    end

    


  end
end
