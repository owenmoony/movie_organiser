require 'rubygems'
require 'cgi'
require 'open-uri'
require 'nokogiri'

class ImdbMovie

  attr_reader :year

  def initialize(title, year)
    @movie  = find_movie_page(title, year)
    raise ArgumentError.new("Movie not found in imdb with args: #{@title} #{@year}") if @movie['Title'].blank?
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
    url = "http://www.imdbapi.com/?t=#{CGI.escape(title)}&tomatoes=true"
    url += "&y=#{year}" if !year.blank?
    json = get(url)
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