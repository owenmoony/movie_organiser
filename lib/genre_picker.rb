class GenrePicker

  GENRE_PRIORITY = ["Animation",
      "Musical",
      "Family",
      "Romance",
      "Horror",
      "Sci-Fi",
      "Fantasy",
      "Western",
      "Biography",
      "Documentary",
      "War",
      "History",
      "Thriller",
      "Mystery",
      "Comedy",
      "Action",
      "Crime",
      "Music",
      "Adventure",
      "Drama",
      "Game-Show",
      "Film-Noir",
      "News",
      "Reality-TV",
      "Sport",
      "Talk-Show"]


  def self.order(genres)
    return [] if !genres
    h = {}
    genres.each do |genre|
      index = GENRE_PRIORITY.index(genre)
      index = !index ? 1000 : index
      h.merge!(index => genre)
    end
    h.to_a.sort {|a,b| a[0]<=>b[0]}.collect{|a,b| b}
  end


end