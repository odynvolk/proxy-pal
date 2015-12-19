require 'open-uri'

module Scraper
  extend self

  def scrape(urls)
    all_proxies = []

    urls.each do |url|
      begin
        all_proxies += find_proxies(open(url).read)
      rescue => e
        puts "Failed to scrape #{url}"
      end
    end

    all_proxies.uniq
  end

  def find_proxies(str)
    str = remove_html_tags(str)
    str.scan(/\d+\.\d+\.\d+\.\d+:\d{2,4}/)
  end

  def remove_html_tags(str)
    re = /<("[^"]*"|'[^']*'|[^'">])*>/
    str.gsub(re, '')
  end

end