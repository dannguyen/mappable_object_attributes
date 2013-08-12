require 'spec_helper_with_ar'

describe "Interaction with ActiveRecord" do

  class AliceMap < ActiveRecord::Base 
    include MappableData

    define_attributes_map do |alice|
      alice.name = :name
      alice.hed = :headline
      alice.birth_year = ->(data){DateTime.parse(data.birthday).year}
    end

    define_attributes_map(:secondary) do |alice|
      alice.name = :name
      alice.hed = :hed
      alice.birth_year = ->(data){DateTime.parse(data.birthday).year}
    end
  end

  describe '#build_from_map' do 
    before(:each) do 
      @data_obj = {'name' => 'Al', 
          'headline' => "A Head", 
          'hed' => 'Other Hed', 
          'birthday' => "1999-01-12"}
      @alice = AliceMap.build_from_map(@data_obj)
    end

    it 'should be a new record' do 
      expect(@alice.new_record?).to be_true
    end

    it 'should have mapped attributes' do 
      expect(@alice.name).to eq 'Al'
      expect(@alice.hed).to eq 'A Head'
      expect(@alice.birth_year).to eq 1999
    end

    it 'should accept second argument to build from a specified map' do 
      @alice2 = AliceMap.build_from_map @data_obj, :secondary
      expect(@alice2.hed).to eq 'Other Hed'
    end

    describe '#create_from_map' do 
      it 'should create record similar to #build_from_map' do 
        @alice = AliceMap.create_from_map(@data_obj)
        expect(@alice.new_record?).not_to be_true 
        expect(@alice.hed).to eq 'A Head'
      end
    end
  end
end
