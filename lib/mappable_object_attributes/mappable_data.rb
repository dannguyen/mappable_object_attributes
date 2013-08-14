require 'active_support/core_ext'
module MappableObjectAttributes; 
  module MappableData 
    extend ActiveSupport::Concern

    included do
      class_attribute :data_maps
      self.data_maps ||= Hashie::Mash.new

      class_attribute :is_activerecord
      self.is_activerecord = self <= ActiveRecord::Base
    end


    module ClassMethods
      def define_attributes_map(mapname=:default, &block)
        data_map = self.init_map_named(mapname)  
        # let the model-designer define the mash here
        yield data_map

        # now make accessible if ActiveRecord
        if self.is_activerecord & self.respond_to?(:attr_accessible)
          data_map.keys.each do |mkey|
            #attr_accessible mkey
          end
        end

        return data_map 
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
      def make_hash_from(hash_object, mapname=:default)
        data_mash = Hashie::Mash.new(hash_object)
        built_mash = Hashie::Mash.new

        # build from the specified data_attributes_map
        specific_data_map = self.fetch_map_named(mapname)
        specific_data_map.each_pair do |key, proc|
          built_mash[key] = proc.call(data_mash)
        end

        return built_mash
      end


      # ActiveRecord specific
      def build_from_map(hash_object, mapname=:default)
        instance = self.new
        instance.assign_attributes_from_hash(hash_object, mapname)

        return instance
      end

      def create_from_map(hash_object, mapname=:default)
        instance = build_from_map(hash_object, mapname)
        instance.save

        return instance
      end

      # pre: Has access to ActiveController
      def make_mapped_atts_accessible(data_hsh)
        params = ActionController::Parameters.new(data_hsh)
        permitted_params = params.permit!
        return permitted_params
      end

    end # END OF Class Methods


    ###################### instance methods

    # usage: convenience method that calls:
    #  - make_hash_from
    #  - makes attributes accessible
    #  - assign_attributes
    #  part of #build_from_map
    def assign_attributes_from_hash(hash_object, mapname=:default)
      msh = self.class.make_hash_from(hash_object, mapname)
      accessible_msh = self.class.make_mapped_atts_accessible(msh)

      self.assign_attributes(accessible_msh)
    end



    private


  end
end




=begin  # deprecated non AR stuff
old      def build_from_map(hash_object, mapname=:default)

        hsh = make_hash_from(hash_object, mapname)
        obj = self.new
        hsh.each_pair do |k,v|
          obj.send("#{k}=".to_sym, v)
        end

        return obj
      end

=end        

