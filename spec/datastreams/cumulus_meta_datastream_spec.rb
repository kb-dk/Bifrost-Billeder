require 'spec_helper'

describe CumulusMetaDatastream do

  before(:each) do
     #fixture :image
    #@sample = fixture("image.xml")
    #@sample = fixture_file_upload("image.xml")
    @sample = Rails.root.join("test", "fixtures", "image.xml")
    @ds = CumulusMetaDatastream.from_xml(@sample)
  end

  it "should expose titles for an image" do
    @ds.title.should == ["Georg Brandes"]
  end


  it "should expose description for an image" do
    @ds.description.should == ["Forside af ke000002"]
  end


  it "should expose fileidentifier for an image" do
    @ds.fileidentifier.should == ["ke000001.tif"]
  end

end