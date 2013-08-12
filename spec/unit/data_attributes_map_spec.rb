require 'spec_helper'



describe 'DataAttributesMap' do 

  context 'end result of #set_map_att_foo' do 


    class BobMap
      include MappableData

      define_attributes_map do |bob|
        bob.name = :name
        bob.hed = :headline
        bob.birth_year = ->(data){DateTime.parse(data.birthday).year}
      end
    end

    before(:each) do 
      @data_obj = {'name' => 'Bob', 
        'headline' => "A headline", 
        'hed' => 'Should be ignored', 
        'birthday' => "1985-01-12"}
      @bob = BobMap.build_hash_from(@data_obj)
    end

    it 'all mapped values should be Procs' do 
      expect( BobMap.data_attributes_map.values.all?{|p| p.is_a?(Proc)} ).to be true
    end

    context 'value is blank' do 
      it 'should extract :key from data_obj' do 
        expect(@bob.name).to eq 'Bob'
      end
    end

    context 'value is a String or symbol' do 
      it 'should extract :value (as a key) from data_obj' do 
        expect(@bob.hed).to eq 'A headline'
      end
    end

    context 'value is a Proc' do 
      it 'should execute Proc upon the data object' do 
        expect(@bob.birth_year).to eq 1985
      end
      it 'should raise ArgumentError if arity is != 1' do 
        expect{ BobMap.define_attributes_map do |b|
                  b.faulty = ->(data, badarg){'hey'}
                end
        }.to raise_error ArgumentError
      end
    end

    context 'value is something else' do 
      it 'should raise an ArgumentError' do 
        expect{ BobMap.define_attributes_map do |b|
                  b.faulty = {no: 'good'}
                end
        }.to raise_error ArgumentError
      end
    end



  end  
end