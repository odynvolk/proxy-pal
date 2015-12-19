# encoding: utf-8

require 'net/http'
require 'timeout'

class Runner

  def initialize(name, untested_proxies, proxies, max_latency)
    @name = name
    @untested_proxies = untested_proxies
    @proxies = proxies
    @max_latency = max_latency
  end

  def run
    until @untested_proxies.empty?
      begin
        proxy = @untested_proxies.pop_first
        start_time = Time.new

        if is_working?(proxy)
          speed = Time.new - start_time
          puts "#{@name} found #{proxy} speed #{speed}"
          @proxies.add proxy
        end
      rescue => e
        # puts e.backtrace
      end
    end
  end

  private

  def is_working?(proxy)
    proxy = proxy.split ':'

    Timeout::timeout(@max_latency) do
      page = Net::HTTP::Proxy(proxy[0], proxy[1]).start('www.knowops.com') { |http|
        http.get('/cgi-bin/textenv.pl')
      }

      if page.code == '200' && page.body.include?('HTTP_HOST=www.knowops.com')
        return true
      end
    end

    false
  end
end