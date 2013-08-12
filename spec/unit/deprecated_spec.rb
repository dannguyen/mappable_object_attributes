## legacy methods to be changed or deprecated

require 'spec_helper'


class SomePerson
  include MappableData

  define_attributes_map do |person|
    person.map_simple_atts :name, :age, :category
    person.map_nested_att :zipcode, [:address, :zip]
    person.map_nested_att :street_name, [:address, :street, :name]

  end

end

describe 'deprecated convenience methods' do 

  before(:each) do 
    @data_obj = {name: 'Charlie', age: 12, category: 'Runner', 
      address: {zip: 90210, street: {name: 'Broadway', number: 100}}
    }

    @person_hash = SomePerson.make_hash_from(@data_obj)
  end


  context '#map_simple_atts' do 
    it 'should map simple attributes' do 
      expect(@person_hash.name).to eq 'Charlie'
      expect(@person_hash.age).to eq 12
    end
  end

  context '#map_nested_att' do 
    it 'should map nested attributes' do 
      expect(@person_hash.zipcode).to eq 90210
      expect(@person_hash.street_name).to eq 'Broadway'
    end
  end


end