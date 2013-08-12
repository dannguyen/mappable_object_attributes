require 'spec_helper'


class MappedObj
  include MappableData

  define_attributes_map do |o|
    o.name = :name
  end

end

describe 'MappableData' do 

  it 'should have @@data_maps' do 
    expect(MappedObj.data_maps).to be_a Hashie::Mash
  end


  describe '#define_attributes_map' do 
    it 'should define :default map by default' do 
      expect(MappedObj.mapped_attribute_keys(:default) ).to eq [:name]
    end

    it 'should have named @@data_attributes_map[:hello]' do 
      MappedObj.define_attributes_map(:hello){|o| }
      expect(MappedObj.fetch_map_named(:hello)).to be_a DataAttributesMap
    end
  end

end