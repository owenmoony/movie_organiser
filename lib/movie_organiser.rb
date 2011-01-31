require 'lib/imdb_movie'
require 'lib/genre_picker'
require 'lib/filename_parser'

class MovieOrganiser


  def initialize(src_dir)
    @files = Dir.glob("#{src_dir}/*")
    log :info, "Found '#{@files.size}' files in '#{src_dir}'."
  end

  def find_movies
    @movies = []
    @files.each do |filename|
      movie = {}
      log :info, "\nProcessing file: '#{File.basename(filename)}'"
      movie[:imdb] = get_movie(filename)
      movie[:filename] = filename
      if !movie[:imdb]
        log :error, "Couldn't process this movie, moving to next."
      else
        @movies << movie
      end
    end
  end

  def migrate_movies
    if @movies.empty?
      log :error, "No movies to migrate?!"
    else
      @movies.each do |movie|
        execute_shell_commands(movie[:imdb], movie[:filename])
      end
    end
  end

  private

  def execute_shell_commands(movie, filename)
    genre = GenrePicker.order(movie.genres).first
    title_and_year = movie.imdb_title + " " + movie.year
    ext = File.extname(filename)
    path = File.dirname(filename)

    genre_dir = File.join(path, genre)
    new_filename = [File.join(genre_dir, clean(title_and_year)), movie.rating].join(" - ") + ext
    cmds = []
    cmds << "mkdir -p '#{genre_dir}'"
    cmds << "mv '#{filename}' '#{new_filename}'"
    puts "Moving file '#{File.basename(filename)}' --> '#{new_filename.split("/")[-2..-1].join("/")}'"

    log :question, "Execute? (y/n)"
    response = STDIN.gets.strip.downcase
    if response == 'y'
      cmds.each { |cmd| `#{cmd}` }
    end
  end

  def clean(title)
    title.gsub(/\:|\*|`|%|\$|'|,|\?|:/, '')
  end

  def get_movie(filename)
    title, year = FilenameParser.normalize_name(File.basename(filename))
    if title
      begin
        return ImdbMovie.new(title, year)
      rescue ArgumentError => e
        log :error, "Movie could not be found in imdb. Try changing the filename and year to match imdb."
        return nil
      end
    else
      log :error, "Could not parse file '#{File.basename(filename)}'... normalize_name failed."
    end
  end

  def log(level, msg)
    case level
      when :info then
        puts msg
      when :error then
        puts red(msg)
      when :question then
        puts green(msg)
      else
        puts gray(msg)
    end
  end

  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def red(text); colorize(text, 31); end
  def green(text); colorize(text, 32); end
  def gray(text); colorize(text, 30); end

end