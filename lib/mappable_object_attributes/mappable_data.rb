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

      def mapped_attribute_keys
       self.data_attributes_map.keys
      end

      # This is called by an importing function, with the expectation
      # that @@data_attributes_map has been defined
      #
      # Returns a Hashie::Mash that assign_attributes/update_attributes
      # can be called from
      def build_hash_from(hash_object)
        data_mash = Hashie::Mash.new(hash_object)
        built_mash = Hashie::Mash.new

        data_mash = Hashie::Mash.new(hash_object)
        self.data_attributes_map.each_pair do |key, proc|
          built_mash[key] = proc.call(data_mash)
        end

        # TODO:
        # create a callback to allow derivations 
#        yield built_mash if block_given?
        # or should this be logic inside the model's initialization??
        
        return built_mash
      end




    end



  end
end
