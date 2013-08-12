require 'active_support/core_ext'

module MappableObjectAttributes; 
  module MappableData 
    extend ActiveSupport::Concern

    included do
      class_attribute :data_maps
      self.data_maps ||= Hashie::Mash.new
    end


    module ClassMethods
      def define_attributes_map(mapname=:default, &block)
        datamap = self.init_map_named(mapname)  
        # let the model-designer define the mash here
        yield datamap

        return datamap 
      end

      def default_data_map
        data_maps[:default]
      end

      def mapped_attribute_keys(mapname=:default)
       data_maps.fetch(mapname).map_keys
      end

      def fetch_map_named(mapname)
        data_maps.fetch(mapname)
      end

      def init_map_named(mapname)
        data_maps[mapname] ||= DataAttributesMap.new 
      end

      # This is called by an importing function, with the expectation
      # that @@data_attributes_map has been defined
      #
      # Returns a Hashie::Mash that assign_attributes/update_attributes
      # can be called from
      def build_hash_from(hash_object, mapname=:default)
        data_mash = Hashie::Mash.new(hash_object)
        built_mash = Hashie::Mash.new

        # build from the specified data_attributes_map
        specific_data_map = self.fetch_map_named(mapname)
        specific_data_map.each_pair do |key, proc|
          built_mash[key] = proc.call(data_mash)
        end

        # TODO:
        # create a callback to allow derivations 
#        yield built_mash if block_given?
        # or should this be logic inside the model's initialization??

        return built_mash
      end


      # override for activerecord
      def build_from_map(hash_object, mapname=:default)
        hsh = build_hash_from(hash_object, mapname)
        obj = self.new
        hsh.each_pair do |k,v|
          obj.send("#{k}=".to_sym, v)
        end

        return obj
      end


    end



  end
end
