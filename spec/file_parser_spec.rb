require 'filename_parser'

describe "file parser" do

  it "should should normalise the file name" do
    fp = FilenameParser.new
    fp.normalize_name("Aliens 1991 720p BluRay saaaxxx").should == ["Aliens", "(1991)"]
    fp.normalize_name("The American 2010 1080p oRip Lie XXX yy").should == ["The American", "(2010)"]
    fp.normalize_name("Cars (2006) 720p BluRay x264 XEix").should == ["Cars", "(2006)"]
    fp.normalize_name("Inhale.2010.1080p.Bluray.DTS.X264_R_xx.mkv").should == ["Inhale", "(2010)"]
    fp.normalize_name("after.life.2010.720p.brrip.xvid.ac3-xx.avi").should == ["after life", "(2010)"]
  end

  it "should match when the date is at the end of the line" do
    fp = FilenameParser.new
    fp.normalize_name("shrek 2001").should == ["shrek", "(2001)"]
  end

  it "should not normalise a normalised name" do
    fp = FilenameParser.new
  end

end