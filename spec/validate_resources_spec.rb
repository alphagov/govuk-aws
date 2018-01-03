require 'spec_helper'
require_relative '../lib/validate_resources'

RSpec.describe ValidateResources do
  describe '::validate_resource_name' do
    context 'aws_security_group_rule' do
      it 'should be in format of source_ingress_dest_service' do
        resource = 'aws_security_group_rule'
        rule = /(?<name>(?<source>[^_]+)_(?<direction>(ingress|egress))_(?<destination>.+)_(?<service>.+))/
        expect(ValidateResources.new.validate_resource_name('spec/aws_security_group_rule.tf', resource, rule)).to eq({
          'aws_security_group_rule' => [
            'allow_yellow_from_blue'
          ]
        })
      end
    end
  end
end
