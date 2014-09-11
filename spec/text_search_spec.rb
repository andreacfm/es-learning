require 'spec_helper'

describe 'Text Search' do

  context 'given an indexed item' do
    before do
      $client.index index: 'items', type: 'item', id: 1, body: {name: 'one'}, refresh: true
    end
    it 'should find the item by exact field match in query string' do
      expect($client.search(index: 'items', type: 'item', q: 'name:one')['hits']['total']).to eq(1)
    end
  end

  context 'given 3 books indexed with analyzed title' do
    before do
      mapping = {
          book: {
              properties: {
                  title: {
                      type: :string
                  }
              }
          }
      }
      $client.indices.create index: 'books', type: 'book', body: {mapping: mapping}
      $client.index index: 'books', type: 'book', id: 1, body: {title: 'Testing elasticsearch', price: 10}, refresh: true
      $client.index index: 'books', type: 'book', id: 2, body: {title: 'Es Learning part 1', price: 20}, refresh: true
    end

    specify do
      @response = $client.search(index: 'books', type: 'book', body: {query: {query_string: {query: 'title:elasticsearch'}}})
      expect(res.hits.total).to eq 1
    end

    specify do
      @response = $client.search(index: 'books', type: 'book', body: {
          min_score: 0.7,
          query: {query_string: {query: 'title:elasticsearch'}}
      })
      expect(res.hits.total).to eq 0
    end

    specify do
      @response = $client.search(index: 'books', type: 'book', body: {
          fields: ['_source'],
          script_fields: {
              with_vat: {
                  script: 'doc["price"].value + 2' }
          },
          query: {query_string: {query: 'title:elasticsearch'}}
      })
      expect(res.hits.hits.first.fields.with_vat).to eq 12
    end

  end

end