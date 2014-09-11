require 'spec_helper'

describe 'cluster' do

	it 'should be up and running' do
		expect( $client.cluster.health['status'] ).not_to  be_nil
	end

end