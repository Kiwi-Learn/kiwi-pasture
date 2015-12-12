require 'dynamoid'

class Search
  include Dynamoid::Document
  field :keyword, :string
  field :course_name, :string
  field :course_url, :string
  field :course_id, :string
  field :course_date, :string

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
