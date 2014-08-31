require 'spec_helper'

describe "basic searching" do

	it 'should' do
		client = Elasticsearch::Client.new log: true
		p client.cluster.health
	end		
  
end