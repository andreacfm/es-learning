require 'spec_helper'

describe 'Stop Words' do

  context 'given 2 books indexed where title use the stopwords analyzer' do
    before do
      settings = {
          analysis:{
              analyzer:{
                title_analyzer:{
                    type: 'stop'                }
              }
          }
      }
      mapping = {
          book: {
              properties: {
                  title: {
                      type: :string,
                      analyzer: 'title_analyzer'
                  }
              }
          }
      }
      $client.indices.create index: 'books', type: 'book', body: {mapping: mapping, settings: settings}
      $client.index index: 'books', type: 'book', id: 1, body: {title: 'Testing and running'}, refresh: true
      $client.index index: 'books', type: 'book', id: 2, body: {title: 'la casa in campagna'}, refresh: true
    end

    specify do
      @response = $client.search(index: 'books', type: 'book', body:{ query:{ term:{ title: 'testing' }}})
      expect(res.hits.total).to eq 1
    end

    specify do
      @response = $client.search(index: 'books', type: 'book', body:{ query:{ term:{ title: 'and' }}})
      expect(res.hits.total).to eq 0
    end

  end

end