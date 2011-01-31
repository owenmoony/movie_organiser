require 'rubygems'
require 'cgi'
require 'open-uri'
require 'nokogiri'

class ImdbMovie

  attr_reader :year

  def initialize(title, year)
    @movie  = find_movie_page(title, year)
    raise ArgumentError.new("Movie not found in imdb with args: #{@title} #{@year}") unless title
  end

  def genres
    @movie['Genre'].split(",")
  end

  def rating
    @movie['Rating']
  end

  def title
    @movie['Title']
  end

  def year
    @movie['Year']
  end

  def tomato_rating
    s = @movie['tomatoRating']
    "N/A" == s ? nil : s
  end

  private

  def find_movie_page(title, year)
    puts "searching imdb for '#{title} #{year}', please wait..."
    json = get("http://www.imdbapi.com/?t=#{CGI.escape(title)}&y=#{year}&tomatoes=true")
    ActiveSupport::JSON.decode(json)
  end

  def get(uri)
    open(uri) do |f|
      @status = f.status.first
      if "200" == @status
        return f.read
      else
        puts "Got HTTP code #{@status} - could not get: #{uri}"
        return nil
      end
    end
  end

end