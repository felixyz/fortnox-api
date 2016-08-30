require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types::Sized do

  shared_examples_for 'Sized Types' do
    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end
  end

  shared_examples_for 'equals input' do |input|
    subject{ described_class[ input ] }
    it{ is_expected.to eq input }
  end

  shared_examples_for 'raises ConstraintError' do |input|
    subject{ ->{ described_class[ input ] } }
    it{ is_expected.to raise_error(Dry::Types::ConstraintError) }
  end

  describe 'String' do
    max_size = 5
    let( :described_class ){ Fortnox::API::Types::Sized::String[ max_size ] }

    it_behaves_like 'Sized Types'

    context 'created with empty string' do
      include_examples 'equals input', ''
    end

    context 'created with fewer characters than the limit' do
      include_examples 'equals input', 'a' * (max_size - 1)
    end

    context 'created with valid string' do
      include_examples 'equals input', 'a' * max_size
    end

    context 'created with more characters than the limit' do
      include_examples 'raises ConstraintError', 'a' * (max_size + 1)
    end
  end

  shared_examples_for 'Sized Numeric' do |min, max, step|
    it_behaves_like 'Sized Types'

    context 'created with value below the lower limit' do
      include_examples 'raises ConstraintError', min - step
    end

    context 'created with value at the lower limit' do
      include_examples 'equals input', min
    end

    context 'created with valid number near lower limit' do
      include_examples 'equals input', min + step
    end

    context 'created with valid number near upper limit' do
      include_examples 'equals input', max - step
    end

    context 'created with value at the upper limit' do
      include_examples 'equals input', max
    end

    context 'created with value above the upper limit' do
      include_examples 'raises ConstraintError', max + step
    end
  end

  describe 'Float' do
    min = 0.0
    max = 100.0
    it_behaves_like 'Sized Numeric', min, max, 0.1 do
      let( :described_class ){ Fortnox::API::Types::Sized::Float[ min, max ] }
    end
  end

  describe 'Integer' do
    min = 0
    max = 100
    it_behaves_like 'Sized Numeric', min, max, 1 do
      let( :described_class ){ Fortnox::API::Types::Sized::Integer[ min, max ] }
    end
  end
end
