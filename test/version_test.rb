require 'test_helper'

describe Hanami::Helpers::VERSION do
  it 'exposes version' do
    Hanami::Helpers::VERSION.must_equal '1.0.0.rc1'
  end
end
