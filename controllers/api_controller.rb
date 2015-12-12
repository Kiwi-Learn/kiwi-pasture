require_relative 'course_helpers'
require_relative 'search_helpers'

##
# - requires config:
#   - create ENV vars AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_REGION
class KiwiPasture < Sinatra::Base
  helpers CourseHelpers, SearchHelpers

  show_old_version_deprecation = lambda do
    status 400
    "Version #{@ver} of Kiwi Pasture API is deprecated: please use " +
    "<a href=\"#{settings.api_ver}\">#{request.host}/#{settings.api_ver}</a>"
  end

  show_root = lambda do
    "KiwiPasture API v2 is up and running at " +
    "<a href=\"#{settings.api_ver}\">#{request.host}/#{settings.api_ver}</a>"
  end

  api_get_root = lambda do
    'Hello there!! This is Kiwi pasture service. Current API version is v2. Now we have deployed our service on Heroku. Please feel free to explore it!' \
      'See Homepage at <a href="https://github.com/Kiwi-Learn/kiwi-pasture">' \
      'Github repo</a>'
  end

  api_get_info = lambda do
    content_type :json
    get_course(params[:id]).to_json
  end

  api_post_search = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
    rescue
      halt 400
    end

    # TODO:
    # Query Database to get searched results.
    # If result in Database redirect to the correct route

    # search = Search.find_by_keyword(req['keyword'])
    # if search
    #   # status 201
    #   redirect "/api/v2/searched/#{search.id}", 303
    # end

    # TODO:
    # If result not in Database call API to make a search
    # begin
    #   results = search_course(req['keyword'])
    # rescue
    #   halt 500, 'Lookup of ShareCourse failed'
    # end

    # TODO:
    # After called the API got the results Insert to Database
    # if results.name
    #   search = Search.new(
    #     keyword: req['keyword'],
    #     course_name: results.name,
    #     course_id:results.id,
    #     course_url:results.url,
    #     course_date: results.date)
    #
    #   if search.save
    #     status 201
    #     redirect "/api/v2/searched/#{search.id}", 303
    #   else
    #     halt 500, 'Error saving tutorial request to the database'
    #   end
    # else
    #   # if result return nil, redirect to not found
    #   redirect '/api/v2/searched/notfound', 303
    # end

    # search_course(req['keyword']).to_json
  end

  api_get_notfound = lambda do
    status 204
    'Course not found!'
  end

  api_get_searched = lambda do
    content_type :json
    # TODO: Query searched results from Database
    # begin
    #   search = Search.find(params[:id])
    #   keyword = search.keyword
    # rescue
    #   halt 400
    # end
    #
    # { keyword: keyword,
    #   course_id: search.course_id,
    #   course_name: search.course_name,
    #   course_url: search.course_url,
    #   course_date: search.course_date
    # }.to_json
  end

  api_get_courselist = lambda do
    get_course_list().to_json
  end

  capture_api_ver = lambda do |ver|
    @ver = ver
    pass
  end

  # API handlers
  get '/', &show_root

  get %r{/api/(v\d)/*}, &capture_api_ver
  put %r{/api/(v\d)/*}, &capture_api_ver
  post %r{/api/(v\d)/*}, &capture_api_ver
  delete %r{/api/(v\d)/*}, &capture_api_ver

  get '/api/v1/?*', &show_old_version_deprecation

  # Web API Routes
  get '/api/v2/?', &api_get_root

  get '/api/v2/info/:id.json', &api_get_info

  get '/api/v2/searched/notfound', &api_get_notfound
  # get '/api/v2/searched/:id', &api_get_searched
  # post '/api/v2/search', &api_post_search

  get '/api/v2/courselist', &api_get_courselist

end
