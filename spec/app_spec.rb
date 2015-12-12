require_relative 'spec_helper'
require_relative 'support/story_helpers'
require 'json'

describe 'KiwiPasture Stories' do
  include StoryHelpers
  describe 'Getting the root of the service' do
    it 'Should return ok' do
      get '/api/v2'
      last_response.must_be :ok?
      last_response.body.must_match(/Kiwi pasture service/)
    end
  end

  describe 'Getting the detail of course' do
    it 'Should return ok' do
      get '/api/v2/info/MA02004.json'
      last_response.must_be :ok?
      last_response.body.must_match(/"id":"MA02004"/)
    end
  end

  describe 'Course List' do
    it 'Should return course list' do
      get '/api/v2/courselist'
      last_response.must_be :ok?
    end
  end
end


describe 'Searching course' do
  before do
    Search.delete_all
  end

  it 'Should return course info' do
    header = { 'CONTENT_TYPE' => 'application/json' }
    body = {
      keyword: 'program'
    }

    # Check redirect URL from post request
    post '/api/v2/search', body.to_json, header
    last_response.must_be :redirect?
    next_location = last_response.location
    # next_location.must_match %r{api\/v2\/searched\/\d+}

    # Check if request parameters are stored in ActiveRecord data store
    ser_id = next_location.scan(%r{searched\/(\d+)}).flatten[0].to_i
    saved_keyword = Search.where(:keyword => body[:keyword]).all[0].keyword
    saved_keyword.must_equal body[:keyword]

    follow_redirect!
    # last_request.url.must_match %r{api\/v2\/searched\/\d+}

    # Check if redirected response has results
    JSON.parse(last_response.body).count.must_be :>, 0
  end
end
