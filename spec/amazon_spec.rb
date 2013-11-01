require 'amazon'
require 'spec_helper'

describe Amazon::S3 do
  before(:each) { stub_request(:any, /s3.amazonaws.com/) }

  let(:options) { {access_key: 'x', secret_key: 'x', bucket_name: 'example_site'} }
  let(:bucket) { Amazon::S3.new(options.merge(source_path: TMP_PATH)) }
  let(:changeset) { double(updated: ["example", "sample"], removed: ["another", "other"]) }

  it "deploys each file in the given changeset" do
    create_file!("example", "example content")
    create_file!("sample", "sample content")
    bucket.deploy(double(updated: ["example", "sample"], removed: []))
    assert_requested :put, "https://s3.amazonaws.com/example_site/example", :body => "example content", :times => 1
    assert_requested :put, "https://s3.amazonaws.com/example_site/sample", :body => "sample content", :times => 1
  end

  it "removes each file in the given changeset" do
    ensure_path!(TMP_PATH)
    bucket.deploy(double(removed: ["example", "sample"], updated: []))
    assert_requested :delete, "https://s3.amazonaws.com/example_site/example", :times => 1
    assert_requested :delete, "https://s3.amazonaws.com/example_site/sample", :times => 1
  end

  it "raises an ArgumentError when not given an :access_key" do
    expect {Amazon::S3.new(options.delete_if{|k,v| k == :access_key})}.to raise_error(ArgumentError)
  end

  it "raises an ArgumentError when not given an :secret_key" do
    expect {Amazon::S3.new(options.delete_if{|k,v| k == :secret_key})}.to raise_error(ArgumentError)
  end

  it "raises an ArgumentError when not given an :bucket_name" do
    expect {Amazon::S3.new(options.delete_if{|k,v| k == :bucket_name})}.to raise_error(ArgumentError)
  end
end
