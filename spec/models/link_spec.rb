require 'rails_helper'

RSpec.describe Link, :type => :model do
  it 'should standardize target_url by removing http://' do
    link = Link.new(:slug => 'test', :target_url => 'http://example.com')
    link.standardize_target_url!

    expect(link.target_url).to eq('example.com')
  end

  it 'should standardize target_url by removing https://' do
    link = Link.new(:slug => 'test', :target_url => 'https://example.com')
    link.standardize_target_url!

    expect(link.target_url).to eq('example.com')
  end
end
