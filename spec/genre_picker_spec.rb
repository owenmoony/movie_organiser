require 'genre_picker'

describe "genre picker" do

  it "should return the genres ordered correctly" do
    all_genres = ["Action", "Adventure", "Animation", "Biography",
                  "Comedy", "Crime", "Documentary", "Drama",
                  "Family", "Fantasy", "Film-Noir", "Game-Show",
                  "History", "Horror", "Music", "Musical",
                  "Mystery", "News", "Reality-TV", "Romance",
                  "Sci-Fi", "Sport", "Talk-Show", "Thriller",
                  "War", "Western"]
    GenrePicker.new.order(all_genres).first.should == "Animation"
    GenrePicker.new.order(all_genres).last.should == "Talk-Show"
  end

  it "should give me the best from two genres" do
    GenrePicker.new.order(["Action", "Sci-Fi"]).first.should == "Sci-Fi"
  end

  it "should work when there is only genre" do
    GenrePicker.new.order(["Sci-Fi"]).first.should == "Sci-Fi"
  end

  it "should work when given nil" do
    GenrePicker.new.order(nil).should == []
  end

  it "should work for an unknown genre" do
    GenrePicker.new.order(["AAA", "Drama"]).should =~ ["Drama", "AAA"]
  end

end