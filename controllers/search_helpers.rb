module SearchHelpers
  def new_search(req, scraped_result)
    search = Search.new
    search.keyword = req['keyword']
    search.course_name = scraped_result.name
    search.course_id = scraped_result.id
    search.course_url = scraped_result.url
    search.course_date = scraped_result.date
    search
  end

  def scraper_search_course(keyword)
    Course.new(nil, keyword)
  rescue
    halt 404
  end
end
