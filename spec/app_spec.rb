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
