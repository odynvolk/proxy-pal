# encoding: UTF-8

require 'core/persistent_collection'
require 'io/file_util'
require 'io/scraper'
require 'runner'
require 'settings'
require 'yaml'
require 'date'

class ProxyPal
  def initialize
    @start_time = Time.new
    puts "Initializing ProxyPal... #{@start_time}"

    Settings.load!('../config.yml')

    @config = FileUtil.read_yml '../config.yml'
    @last_scrape = FileUtil.read_yml '../last_scrape.tmp'
    @last_scrape['dateTime'] = (DateTime.now - 30) if @last_scrape['dateTime'].nil?
  end

  def run
    keep_alive

    time_elapsed
  end

  private

  def keep_alive
    while true
      test_start_time = Time.new
      scrape

      check

      test_end_time = Time.new
      time_diff = test_end_time - test_start_time
      minutes = time_diff.round / 60

      puts "Test time: #{minutes} minutes"
      puts "Sleeping #{@config['sleep_between_runs']} mins between runs."
      sleep (@config['sleep_between_runs'] * 60)
    end
  end

  def scrape
    return if (@last_scrape['dateTime'] > (DateTime.now - 1))

    puts 'Proxies to check are old. Scraping new ones.'

    to_test = FileUtil.read_string(@config['proxies']['to_test_file']).split(/(\n)/)
    to_test = [] if to_test.nil?

    scraped = Scraper.scrape @config['proxies']['sources']
    puts "Scraped #{scraped.size} proxies."

    proxies = (to_test + scraped).uniq.shuffle
    if proxies.size > @config['proxies']['to_test_maximum']
      proxies = proxies[0...@config['proxies']['to_test_maximum']]
    end

    FileUtil.write_string @config['proxies']['to_test_file'], proxies.join("\n")

    @last_scrape['dateTime'] = DateTime.now
    FileUtil.write_yml '../last_scrape.tmp', @last_scrape

    puts "Testing #{proxies.size} proxies."
  end

  def check
    puts 'Checking proxies...'
    runners = []
    proxies = PersistentCollection.new({output_file: @config['proxies']['file']})
    untested_proxies = SynchronizedCollection.new @config['proxies']['to_test_file']

    for i in (0...@config['number_threads']) do
      runner = Runner.new "Runner#{i}", untested_proxies, proxies, @config['max_latency']
      runners << Thread.new(runner) {
        runner.run
      }
    end
    runners.each { |thread| thread.join }

    proxies.save
    puts "Number of proxies: #{proxies.size}"
  end

  def time_elapsed
    end_time = Time.new
    time_diff = end_time - @start_time
    minutes = time_diff.round / 60

    puts "Time elapsed: #{minutes} minutes\nFinished: #{end_time}"
    puts "\a"
  end
end

main = ProxyPal.new
main.run