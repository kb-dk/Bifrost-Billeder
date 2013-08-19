require 'spec_helper'

describe CumulusMetaDatastream do

  before(:each) do
     fixture :image
   # @sample = fixture("sample_metadata.xml")
    @sample = fixture_file_upload("image.xml")
    @ds = CumulusMetaDatastream.from_xml(@sample)
  end

  it "should expose titles for an image" do
    @ds.title.should == ["Georg Brandes"]
  end


  it "should expose description for an image" do
    @ds.description.should == ["Forside af ke000002"]
  end


  it "should expose path_to_image for an image" do
    @ds.path_to_image.should == ["/online_master_arkiv_6/non-archival/Images/BILLED/2008/Billede/kendis/ke000001.tif"]
  end

end