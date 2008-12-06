# Synkage, the ability to synchronize over plain HTML+HTTP.
# Once done, this will be part of Leafman.
require 'rubygems' rescue nil # it doesn't matter if they don't have RubyGems installed, it just makes it easier.
require 'uri'
require 'net/http'
require 'open-uri'
require 'hpricot'
require 'time'
require 'fileutils'
require 'digest/sha2'
class Synkage
    attr :base_url, :sync_into
    def initialize(base_url, sync_into)
        @base_url, @sync_into = base_url, sync_into
    end
    def fetch_whats
        whats = []
        do_follow = proc do |url|
            page = Hpricot(open(url).read)
            burl_uri = URI.parse(escape(@base_url))
            page.search('a.dir').each do |elem|
                do_follow.call(escape("http://#{burl_uri.host}:#{burl_uri.port}#{elem[:href]}"))
            end
            page.search('a.file').each do |elem|
                whats << elem[:href].sub(/^#{Regexp.escape(unescape(burl_uri.path))}/, '').sub(/^\//, "")
            end
        end
        do_follow.call(escape(@base_url))
        return whats
    end
    def up_to_date? what
        return false unless File.exists?(local_path_for(what))
        burl_uri = URI.parse(escape(@base_url))
        hsh = Net::HTTP.start(burl_uri.host, burl_uri.port){|http|http.head(burl_uri.path+"/#{what}")['SHA2-Hash']}
        return(hsh == Digest::SHA2.file(local_path_for(what)).hexdigest)
    end
    def local_path_for what
        File.join(@sync_into, what)
    end
    def remote_path_for what
        "#{@base_url}/#{what}"
    end
    def self.escape(url)
        url.gsub(/[^A-Za-z0-9:\/.-_]/){|input|"%"+input[0].to_s(16)}
    end
    def self.unescape(url)
        url.gsub(/\%([A-Fa-f0-9]{1,2})/){$1.to_i(16).chr}
    end
    def expand_dir_for *whats
        whats.each {|what| FileUtils.mkdir_p(File.dirname(local_path_for(what))) }
    end
    def download_each_of *whats
        whats.each {|what| download(what) unless up_to_date? what }
    end
    def download(what)
        uri = URI.parse(escape(remote_path_for(what)))
        f = File.open(local_path_for(what), 'w')
        Net::HTTP.start uri.host, uri.port do |http|
            http.request_get uri.path do |res|
                f.chmod res['UNIX-Mode'].to_i(8)
                res.read_body {|seg| f.write seg}
            end
        end
        f.close
    end
end
