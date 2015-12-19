require 'spec_helper'
require 'io/file_util'
require 'io/scraper'

describe Scraper do
  it "should remove html tags" do
    str = FileUtil.read_string('./spec/fixtures/example.html')
    expect(str.length).to eq(99)

    str = Scraper.remove_html_tags(str)
    expect(str.length).to eq(45)
  end

  it "should find proxies when ip and port are separated only by :" do
    str = FileUtil.read_string('./spec/fixtures/proxies.html')
    proxies = Scraper.find_proxies(str)

    expect(proxies.length).to eq(2)
    expect(proxies[0]).to eq('213.208.127.177:3128')
  end
end