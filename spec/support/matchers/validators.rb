RSpec::Matchers.define :be_valid do |model|
  expect_validate( model, true )
end

RSpec::Matchers.define :be_invalid do |model|
  expect_validate( model, false )
end

RSpec::Matchers.define :include_error_for do |model, attribute, error_type|
  match do
    subject.validate( model )
    error_included = false
    subject.violations.any? do |v|
      if v.rule.attribute_name == attribute && v.rule.type == error_type
        error_included = true
      end
    end
    expect( error_included ).to eql( true )
  end

  description{ "include error for #{attribute}" }

  failure_message do
    "expected \"#{subject.violations.inspect}\" to include #{error_type} error for \"#{attribute}\""
  end
end

private

  def expect_validate( model, expected )
    match{ expect( subject.validate( model ) ).to eq( expected ) }

    description{ "validate #{expected}" }

    failure_message{ "expected validator to validate #{expected}" }
  end
