require 'lib/imdb_movie'

class FilenameParser

  def normalize_name(filename)
    match = filename.match(/(.*)([\.|\s|\(][0-9]{4}[\.|\s|\)])/)
    match = filename.match(/(.*)([\.|\s|\(][0-9]{4}[\.|\s|\)]*)/) if !match
    return [nil, nil] unless match
    title = match[1]
    year  = match[2]
    year  = year.include?("(") ? year : "(#{year.strip})"
    year = year.gsub(".", "") if year.include?(".")
    title = title.gsub(".", " ") if title.include?(".")
    [title.strip, year.strip]
  end

  def parse_files(src_dir)
    src_dir ||= 'spec/fixtures'
    files   = Dir.glob("#{src_dir}/*")
    files.each do |filename|
      puts "\n\nProcessing file: '#{File.basename(filename)}'"
      movie = get_movie(filename)
      if !movie
        puts "Couldn't process this movie, moving to next."
        next
      end
      execute_commands(movie, filename)
    end
  end

  private

  def execute_commands(movie, filename)
    genre          = GenrePicker.new.order(movie.genres).first
    title_and_year = movie.imdb_title + " " + movie.year
    ext            = File.extname(filename)
    path           = File.dirname(filename)

    genre_dir      = File.join(path, genre)
    new_filename   = [File.join(genre_dir, clean(title_and_year)), movie.rating].join(" - ") + ext
    cmds           = []
    cmds << "$ mkdir -p '#{genre_dir}'"
    cmds << "$ mv '#{filename}' '#{new_filename}'"
    puts "Moving file '#{File.basename(filename)}' --> '#{new_filename.split("/")[-2..-1].join("/")}'"

    puts "\nExecute? (y/n)"
    response = STDIN.gets.strip.downcase
    if response == 'y'
      cmds.each { |cmd| `#{cmd}` }
    end
  end

  def clean(title)
    title.gsub(/\:|\*|`|%|\$|'|,|\?|:/, '')
  end

  def get_movie(filename)
    title, year = normalize_name(File.basename(filename))
    if title
      begin
        return ImdbMovie.new(title, year)
      rescue ArgumentError => e
        return nil
      end
    else
      puts "Could not parse file '#{File.basename(filename)}'... normalize_name failed."
    end
  end

end


#      puts "Movie title: '#{title}' (Enter to accept, enter value to change, 'n' to skip movie)"
#      users_title = STDIN.gets
#      next if users_title.strip == "n"
#      title = users_title.strip == '' ? title : users_title.strip

#
#          puts "Genre: '#{genre}' (Enter to accept, enter value to change)"
#
#          user_genre = STDIN.gets
#
#          genre      = user_genre.strip == '' ? genre : user_genre.strip
#
#
