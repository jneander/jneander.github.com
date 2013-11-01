require 'changeset'
require 'spec_helper'

describe Changeset do
  let(:changeset) { Changeset.new(old_path: tmp("old"), new_path: tmp("new")) }

  context "for two files with identical content" do
    let!(:file) { create_file!("old/test_file_1") }

    it "indicates no changes" do
      create_file!("new/test_file_1")
      expect(changeset.updated).to match_array([])
      expect(changeset.removed).to match_array([])
    end

    it "indicates updated/removed files when files have different names" do
      create_file!("new/test_file_2")
      expect(changeset.updated).to match_array(["test_file_2"])
      expect(changeset.removed).to match_array(["test_file_1"])
    end

    it "indicates updated/removed files when files have different paths" do
      create_file!("new/subdir/test_file_2")
      expect(changeset.updated).to match_array(["subdir/test_file_2"])
      expect(changeset.removed).to match_array(["test_file_1"])
    end
  end

  context "for two files with different content" do
    let!(:file) { create_file!("old/test_file_1", "example content") }

    it "indicates updated files" do
      create_file!("new/test_file_1", "sample content")
      expect(changeset.updated).to match_array(["test_file_1"])
      expect(changeset.removed).to match_array([])
    end

    it "indicates updated/removed files when files have different names" do
      create_file!("new/test_file_2", "sample content")
      expect(changeset.updated).to match_array(["test_file_2"])
      expect(changeset.removed).to match_array(["test_file_1"])
    end

    it "indicates updated/removed files when files have different paths" do
      create_file!("new/subdir/test_file_2", "sample content")
      expect(changeset.updated).to match_array(["subdir/test_file_2"])
      expect(changeset.removed).to match_array(["test_file_1"])
    end
  end

  it "lists no files for two paths with no files" do
    ensure_path!(tmp("old"))
    expect(changeset.updated).to match_array([])
    expect(changeset.removed).to match_array([])
  end

  it "indicates updated files when origin path does not exist" do
    create_file!("new/test_file")
    expect(changeset.updated).to match_array(["test_file"])
    expect(changeset.removed).to match_array([])
  end

  it "indicates removed files when target path does not exist" do
    create_file!("old/test_file")
    expect(changeset.updated).to match_array([])
    expect(changeset.removed).to match_array(["test_file"])
  end

  it "raises ArgumentError when neither path exists" do
    expect{changeset}.to raise_error(ArgumentError)
  end

  it "initializes immediately" do
    create_file!("old/test_file_1")
    create_file!("new/test_file_2")
    changeset and remove_tmp!
    expect(changeset.updated).to match_array(["test_file_2"])
    expect(changeset.removed).to match_array(["test_file_1"])
  end
end
