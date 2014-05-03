require 'spec_helper'

describe StyleHelper do
  describe '#background_position_to_absolute' do
    subject { StyleHelper.new }
    it 'returns absolute style' do
      background_position_to_absolute('center center').should eq ''
      background_position_to_absolute('left center').should eq 'right: auto;'
      background_position_to_absolute('left bottom')
        .should eq 'top: auto;right: auto;'
      background_position_to_absolute('right top')
        .should eq 'bottom: auto;left: auto;'
    end
  end
end
