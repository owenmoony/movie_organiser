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
      next if GenrePicker::GENRE_PRIORITY.include?(File.basename(filename))
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
      @always_execute = nil
      @movies.each do |movie|
        execute_shell_commands(movie[:imdb], movie[:filename])
      end
    end
  end

  private

  def execute_shell_commands(movie, filename)
    genre = GenrePicker.order(movie.genres).first

    ext = File.extname(filename)
    movie_filename = "#{clean(movie.title)} (#{movie.year}) (#{movie.rating}-#{movie.tomato_rating})#{ext}"

    path = File.join(File.dirname(filename), genre)
    movie_fullpath = File.join(path, movie_filename)

    cmds = []
    cmds << "mkdir -p '#{path}'"
    cmds << "mv '#{filename}' '#{movie_fullpath}'"
    puts "Moving file '#{File.basename(filename)}' --> '#{movie_fullpath.split("/")[-2..-1].join("/")}'"

    unless @always_execute
      log :question, "Execute? (y/n/a)"
      response = STDIN.gets.strip.downcase
      @always_yes = response == 'a'
    end

    if response == 'y' || @always_execute
      cmds.each { |cmd| `#{cmd}` }
    end
  end

  def clean(title)
    title.gsub(/\&|\:|\*|`|%|\$|\'|,|\?|:/, '')
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