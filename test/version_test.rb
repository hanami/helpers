require 'test_helper'

describe Lotus::Helpers::VERSION do
  it 'exposes version' do
    Lotus::Helpers::VERSION.must_equal '0.2.6'
  end
end
