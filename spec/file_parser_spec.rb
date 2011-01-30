require 'filename_parser'

describe "file parser" do

  it "should should normalise the file name" do
    fp = FilenameParser.new
    fp.normalize_name("Aliens 1991 720p BluRay sOmeGeek").should == ["Aliens", "(1991)"]
    fp.normalize_name("The American 2010 1080p RCBDRip Lie Xvxd Rx").should == ["The American", "(2010)"]
    fp.normalize_name("The, American 2010 1080p RCBDRip Lie Xvxd Rx").should == ["The, American", "(2010)"]
    fp.normalize_name("Cars (2006) 720p BluRay x264 REVEiLLE").should == ["Cars", "(2006)"]
  end

  it "should not normalise a normalised name" do
    fp = FilenameParser.new
  end

end