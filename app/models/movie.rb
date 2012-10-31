class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def find_with_same_director
    if (self.director != nil && self.director != '')
      return Movie.find_all_by_director(self.director)
    else
      return []
    end
  end
end
