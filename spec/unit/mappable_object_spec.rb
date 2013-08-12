require 'spec_helper'


class MappedObj
  include MappableData

end

describe 'MappableData' do 

  it 'should have @@data_attributes_map' do 
    expect(MappedObj.data_attributes_map).to be_a DataAttributesMap
  end

end