module MappableObjectAttributes; 
  module MappableData 
    extend ActiveSupport::Concern

    included do
      class_attribute :data_attributes_map
      self.data_attributes_map ||= DataAttributesMap.new
    end



    module ClassMethods
      def define_attributes_map(&block)
        datamap = self.data_attributes_map  
        # let the model-designer define the mash here
        yield datamap

        return datamap 
      end
    end

    

  end
end
