require 'genre_picker'

describe "genre picker" do

  it "should pick the correct genre according to my preferences" do
    all_genres = ["Action", "Adventure", "Animation", "Biography",
                  "Comedy", "Crime", "Documentary", "Drama",
                  "Family", "Fantasy", "Film-Noir", "Game-Show",
                  "History", "Horror", "Music", "Musical",
                  "Mystery", "News", "Reality-TV", "Romance",
                  "Sci-Fi", "Sport", "Talk-Show", "Thriller",
                  "War", "Western"]
    g = GenrePicker.new.order(all_genres)

    i = 0
    g[i].should == "Animation"

    i += 1
    g[i].should == "Musical"

    i += 1
    g[i].should == "Family"

    i += 1
    g[i].should == "Romance"

    i += 1
    g[i].should == "Horror"

    i += 1
    g[i].should == "Sci-Fi"

    i += 1
    g[i].should == "Fantasy"

    i += 1
    g[i].should == "Western"

    i += 1
    g[i].should == "Biography"
    
    i += 1
    g[i].should == "Documentary"

    i += 1
    g[i].should == "War"

    i += 1
    g[i].should == "History"

    i += 1
    g[i].should == "Thriller"

    i += 1
    g[i].should == "Mystery"

    i += 1
    g[i].should == "Comedy"

    i += 1
    g[i].should == "Action"

    i += 1
    g[i].should == "Crime"

    i += 1
    g[i].should == "Music"

    i += 1
    g[i].should == "Adventure"

    i += 1
    g[i].should == "Drama"

  end

  it "should give me the best first" do
    GenrePicker.new.order(["Action", "Sci-Fi"]).first.should == "Sci-Fi"
  end

end