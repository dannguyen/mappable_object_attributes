require 'hashie'

module MappableObjectAttributes
  class DataAttributesMap < BasicObject
    include ::Kernel 

    def initialize
      @mash = ::Hashie::Mash.new      
    end


    def map_keys
      @mash.keys
    end

    # send all setter methods directly to set_map_att_foo
    def method_missing(method_name, *arguments, &block)
      # if it's all word characters and a :setter, 
      #  then pass to the mash as a data attribute
      if method_name.to_s =~ /(\w+)=/
        set_map_att_foo($1, *arguments)
      elsif @mash.respond_to?(method_name)
        @mash.send(method_name, *arguments, &block)
      else
        super
      end
    end 


### TO BE deprecated
### included these methods because I used them in older projects
### and want to make sure this gem is compatible with those older projects



    def map_simple_atts(*args)
      args.each{|k| set_map_att_foo(k, k) }
    end

    def map_nested_att(att_name, nodename)
      path_arr = Array(nodename)
      find_nested_node_foo = ->(msh){
        val = path_arr.inject(msh) do |target_node, att|
          break if target_node.nil?
          target_node.fetch(att, nil)
        end
        val
      }

      set_map_att_foo(att_name, find_nested_node_foo)
    end





### /deprecated stuff



    private 
    # also, all atts are now symbols
    def set_map_att_foo(att, val)
      # processed_lambda_val is returned at the end and will consist of a lambda
      
      processed_lambda_val = case 
      when val.blank?
        # model.somekey = msh[somekey]
        ->(msh){ msh[att] }
      when val.is_a?(::String) || val.is_a?(::Symbol)
        # model.somekey = msh[somevalue]
        ->(msh){ msh[val] }
      when val.is_a?(::Proc) && val.arity == 1 # there should be exactly one argument to the Proc
        # model.somekey = foo(msh)
        val
      else
        raise ::ArgumentError, "The value mapped to :#{att} must be either a String, Symbol, or Proc with arity 1. But #{val} is a #{val.class}"
      end
      
      @mash.store(att.to_sym, processed_lambda_val)
    end


  end  
end
