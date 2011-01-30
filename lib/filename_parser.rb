require 'rubygems'
require 'cgi'
require 'open-uri'
require 'nokogiri'
require 'lib/imdb_movie'

class FilenameParser

  def normalize_name(filename)
    match = filename.match(/(.*)([\s|\(][0-9]{4}[\s|\)])/)
    return [nil, nil] unless match
    title = match[1]
    year  = match[2]
    year  = year.include?("(") ? year : "(#{year.strip})"
    [title.strip, year.strip]
  end

  def initialize

  end

  def parse_files(src_dir)

    src_dir ||= 'spec/fixtures'

    files   = Dir.glob("#{src_dir}/*")

    files.each do |filename|

      puts "\n\n---------------------\n"
      puts "Processing: '#{File.basename(filename)}'"

      if File.directory?(filename)
        title, year = normalize_name(File.basename(filename))
        if title
          path           = File.dirname(filename)
          title_and_year = title + " " + year
          puts "Movie Name: '#{title_and_year}' (Enter to accept, enter value to change, 'n' to skip movie)"

          users_title = STDIN.gets

          next if users_title.strip == "n"

          title_and_year = users_title.strip == '' ? title_and_year : users_title.strip

          movie  = ImdbMovie.new(title, year)
          genre  = movie.genres.first
          rating = movie.rating
          title  = movie.title

          puts "Genre: '#{genre}' (Enter to accept, enter value to change)"

          user_genre = STDIN.gets

          genre      = user_genre.strip == '' ? genre : user_genre.strip

          puts "About to enter the following command(s):"
          genre_dir      = File.join(path, genre)
          movie_filename = [File.join(genre_dir, title_and_year), rating].join(" - ")
          cmds           = []
          cmds << "mkdir -p '#{genre_dir}'"
          cmds << "mv '#{filename}' '#{movie_filename}'"
          puts cmds.join("\n")

        else
          puts "Could not parse file '#{File.basename(filename)}'... normalize_name failed."
        end
      end
    end
  end

#  def movie_genres(movie, year)
#    @movie_xml = get_imdb_page(movie, year)
#    nodes      = @movie_xml.xpath("//a[contains(@href,'genre')]")
#    all_genres = nodes.map(&:values)
#    genres     = all_genres.flatten.find_all { |g| g =~ /^\/genre\/.*/ }.uniq
#    return genres.collect { |e| e.gsub(/\/genre\//, '') }
#  end
#
#  def movie_rating(movie, year)
#    @movie_xml ||= get_imdb_page(movie, year)
#    @movie_xml.xpath("//span[@class='rating-rating']").text.split("/").first
#  end

#  def get_imdb_page(movie, year)
#    puts "searching imdb for movie, please wait..."
#    uri        = "http://www.imdb.com/find?s=all&q=#{CGI.escape(movie + " " + year)}"
#    html       = get(uri)
#    xml = Nokogiri.parse(html)
#    if xml.xpath("//title").text =~ /IMDb [Title|Search]/
#      puts "Got the search page, finding the imdb page on the results..."
#      movie_url  = xml.xpath("//*[contains(a, '#{movie}')]").xpath('.//a').first['href']
#      unless movie_url
#        movie_url  = xml.xpath("//*[contains(a, '#{movie[0..3]}')]").xpath('.//a').first['href']
#      end
#      html       = get(URI.join("http://www.imdb.com", movie_url))
#      xml = Nokogiri.parse(html)
#    end
#    puts "Found page: #{xml.xpath("//title").text}"
#    xml
#  end

#  def get(uri)
#    open(uri) do |f|
#      @status = f.status.first
#      if "200" == @status
#        return f.read
#      else
#        puts "!!! Got HTTP code #{@status} and could not get: #{uri}"
#        return nil
#      end
#    end
#  end

end