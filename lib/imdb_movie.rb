require 'rubygems'
require 'cgi'
require 'open-uri'
require 'nokogiri'

class ImdbMovie

  attr_reader :year

  def initialize(title, year)
    @title = title.downcase
    @year  = year
    @page  = find_movie_page
    raise ArgumentError.new("Movie not found in imdb with args: #{@title} #{@year}") unless imdb_title
  end

  def genres
    nodes  = @page.xpath("//a[contains(@href,'genre')]")
    values = nodes.map(&:values)
    genres = values.flatten.find_all { |g| g =~ /^\/genre\/.*/ }.uniq
    return genres.collect { |e| titlecase(e.gsub(/\/genre\//, '')) }
  end

  def rating
    @page.xpath("//span[@class='rating-rating']").text.split("/").first
  end

  def imdb_title
    titlecase(@page.xpath("//h1[@class='header']").inner_text.strip.split("\n").first)
  end

  private

  def find_movie_page
    puts "searching imdb for '#{@title} #{@year}', please wait..."
    html = get("http://www.imdb.com/find?s=all&q=#{CGI.escape(@title + " " + @year)}")
    xml  = Nokogiri.parse(html.downcase)
    if imdb_search_page?(xml)
      puts "Found the search page, finding the imdb page on the results, please wait..."
      movie_url = xml.xpath("//*[contains(a, '#{@title}')]").xpath('.//a').first['href']
      debugger
      if !movie_url || movie_url.include?('find?q=')
        movie_url = xml.xpath("//*[contains(a, '#{@title[0..3]}')]").xpath('.//a').first['href']
      end
      html = get(URI.join("http://www.imdb.com", movie_url))
      xml  = Nokogiri.parse(html.downcase)
    end

    puts "Found page: #{xml.xpath("//title").text}"
    debugger
    xml
  end

  def imdb_search_page?(xml)
    xml.xpath("//title").text =~ /imdb [title|search]/
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

  def titlecase(sentence)
    sentence.gsub(/\b\w/){$&.upcase} if sentence
  end

end