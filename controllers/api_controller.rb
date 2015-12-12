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

    # If Course ID record already in database redirect it
    # searched_result = Search.where(:course_id => params[:id]).all
    # if searched_result[0]
    #   redirect "/api/v2/searched/#{searched_result[0].course_id}", 303
    # end

    # If Course ID does not in database scrape it!
    scraped_results = scrape_course(params[:id])

    # After scraped Insert to database
    # search_result = new_search(req, results)
    # status 201
    scraped_results.to_json
  end

  api_post_search = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
    rescue
      halt 400
    end

    # Query Database to get searched results.
    # If result in Database redirect to the correct route
    searched_result = Search.where(:keyword => req['keyword']).all
    logger.info 'Querying keyword'
    if searched_result[0]
      redirect "/#{settings.api_ver}/searched/#{searched_result[0].course_id}", 303
    end

    # If result not in Database call scrapper to make a search
    logger.info 'Scraping from ShareCourse'
    begin
      results = scraper_search_course(req['keyword'])
    rescue
      halt 500, 'Lookup of ShareCourse failed'
    end

    # If Course ID record already in database do NOT save it again!
    searched_result = Search.where(:course_id => results.id).all
    logger.info 'Querying Course ID'
    if searched_result[0]
      redirect "/#{settings.api_ver}/searched/#{searched_result[0].course_id}", 303
    end

    # After called the scrapper got the results Insert to Database
    logger.info 'Save to database...'
    if results.name
      search_result = new_search(req, results)
      if search_result.save
        status 201
        redirect "/#{settings.api_ver}/searched/#{search_result.course_id}", 303
      else
        halt 500, 'Error saving searched result request to the database'
      end
    else
      # if result return nil, redirect to not found
      redirect "#{settings.api_ver}/searched/notfound", 303
    end
  end

  api_get_notfound = lambda do
    status 204
    'Course not found!'
  end

  api_get_searched = lambda do
    content_type :json
    # Query searched results from Database
    begin
      search = Search.where(:course_id => params[:id]).all
      keyword = search[0].keyword
    rescue
      halt 400
    end

    { keyword: keyword,
      course_id: search[0].course_id,
      course_name: search[0].course_name,
      course_url: search[0].course_url,
      course_date: search[0].course_date
    }.to_json
  end

  api_get_courselist = lambda do
    scrape_course_list().to_json
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
  get '/api/v2/searched/:id', &api_get_searched
  post '/api/v2/search', &api_post_search

  get '/api/v2/courselist', &api_get_courselist

end
