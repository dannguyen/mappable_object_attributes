require 'spec_helper_with_ar'

describe "Interaction with ActiveRecord" do

  describe '#build_from_map' do 
    before(:each) do 
      @data_obj = {'name' => 'Al', 
          'headline' => "A title", 
          'hed' => 'Should be ignored', 
          'birthday' => "1999-01-12"}
      @alice = AliceMap.build_from_map(@data_obj)
    end

  end
end
