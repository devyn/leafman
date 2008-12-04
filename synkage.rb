# Synkage, the ability to synchronize over plain HTML+HTTP.
# Once done, this will be part of Leafman.
require 'rubygems' rescue nil # it doesn't matter if they don't have RubyGems installed, it just makes it easier.
require 'uri'
require 'net/http'
require 'open-uri'
require 'hpricot'
require 'time'
class Synkage
    attr :base_url, :sync_into
    def initialize(base_url, sync_into)
        @base_url, @sync_into = base_url, sync_into
    end
    def recursive_follow
        whats = []
        do_follow = proc do |url|
            page = Hpricot(open(url).read)
            burl_uri = URI.parse(escape(@base_url))
            page.search('a.indir').each do |elem|
                do_follow.call(escape("http://#{burl_uri.host}:#{burl_uri.port}#{elem[:href]}"))
            end
            page.search('a.infile').each do |elem|
                whats << elem[:href].sub(/^#{Regexp.escape(unescape(burl_uri.path))}/, '').sub(/^\//, "")
            end
        end
        do_follow.call(escape(@base_url))
        return whats
    end
    def check_up_to_date(what)
        return false unless File.exists?(local_path_for(what))
        burl_uri = URI.parse(escape(@base_url))
        mtime = Time.parse(Net::HTTP.start(burl_uri.host, burl_uri.port){|http|http.head(burl_uri.path+"/#{what}")['Synkage-Last-Modified']})
        return(mtime == File.stat(local_path_for(what)).mtime)
    end
    def local_path_for what
        File.join(@sync_into, what)
    end
    def remote_path_for what
        "#{@base_url}/#{what}"
    end
    def escape(url)
        url.gsub(/[^A-Za-z0-9:\/.-_]/){|input|"%"+input[0].to_s(16)}
    end
    def unescape(url)
        url.gsub(/\%([A-Fa-f0-9]{1,2})/){$1.to_i(16).chr}
    end
    def expand_dir(for_what)
        
    end
    def download(what)
        
    end
end
