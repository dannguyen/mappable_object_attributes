require 'spec_helper'



describe 'DataAttributesMap' do 

  context 'end result of #set_map_att_foo' do 


    class BobMap
      include MappableData

      define_attributes_map do |bob|
        bob.name = :name
        bob.title = :headline
        bob.birth_year = ->(data){DateTime.parse(data.birthday).year}
      end
    end

    before(:each) do 
      @data_obj = {'name' => 'Bob', 'headline' => "A headline", 'title' => 'Should be ignored', 'birthday' => "1985-01-12"}
    end

    it 'all mapped values should be Procs'

    context 'value is blank' do 
      it 'should extract :key from data_obj'
    end

    context 'value is a String or symbol' do 
      it 'should extract :value (as a key) from data_obj'
    end

    context 'value is a Proc' do 
      it 'should be idempotent if valid'
      it 'should raise ArgumentError if arity is != 1'
    end

    context 'value is something else' do 
      it 'should raise an ArgumentError'
    end



  end  
end