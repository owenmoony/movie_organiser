class GenrePicker

  GENRE_PRIORITY = %w{Animation
      Musical
      Family
      Romance
      Horror
      Sci-Fi
      Fantasy
      Western
      Biography
      Documentary
      War
      History
      Thriller
      Mystery
      Comedy
      Action
      Crime
      Music
      Adventure
      Drama
      Game-Show
      Film-Noir
      News
      Reality-TV
      Sport
      Talk-Show}


  def self.order(genres)
    puts "genres: #{genres.inspect}"
    return "" if genres.nil?
    lowest_index = 1000
    genres.each do |genre|
      index = GENRE_PRIORITY.index(genre.strip)
      lowest_index = index if index && index < lowest_index
    end
    result = lowest_index == 1000 ? genres.first.strip : GENRE_PRIORITY[lowest_index]
    puts "result: #{result}"
    result
  end


end