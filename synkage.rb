# Synkage, the ability to synchronize over plain HTML+HTTP.
# Once done, this will be part of Leafman.
require 'rubygems' rescue nil # it doesn't matter if they don't have RubyGems installed, it just makes it easier.
require 'open-uri'
require 'hpricot'
class Synkage
    attr :base_url, :sync_into
    def initialize(base_url, sync_into)
        @base_url, @sync_into = base_url, sync_into
    end
    def recursive_follow
        
    end
    def check_updated(what)
        
    end
    def escape(url)
        url.gsub(/[^A-Za-z0-9:\/.-_]/){|input|"%"+input[0].to_s(16)}
    end
    def expand_dir(for_what)
        
    end
    def download(what)
        
    end
end
