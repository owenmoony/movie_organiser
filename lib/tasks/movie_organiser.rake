require 'movie_organiser'

desc "run a movie migration"
task :migrate_movies, :src_dir do |t, args|
  mo = MovieOrganiser.new(args[:src_dir])
  mo.find_movies
  mo.migrate_movies
end
