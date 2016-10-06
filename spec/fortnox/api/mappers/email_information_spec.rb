require 'spec_helper'
require 'fortnox/api/mappers/email_information'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::EmailInformation do
  key_map = { 
    email_address_bcc: 'EmailAddressBCC',
    email_address_cc: 'EmailAddressCC'
  }
  json_entity_type = 'EmailInformation'
  json_entity_collection = 'EmailInformation'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper){ described_class.new }
  end
end
