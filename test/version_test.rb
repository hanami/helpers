require 'test_helper'

describe Lotus::Helpers::VERSION do
  it 'exposes version' do
    Lotus::Helpers::VERSION.must_equal '0.1.0'
  end
end
