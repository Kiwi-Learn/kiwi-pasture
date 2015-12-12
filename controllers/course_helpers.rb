require 'json'
require 'concurrent'

module CourseHelpers
  def scrape_course(id)
    Course.new(id, nil)
  rescue => e
    logger.info e
    halt 404
  end

  def scrape_course_list()
    CourseList.new()
  rescue => e
    logger.info e
    halt 404
  end
end
