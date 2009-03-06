Leafman::Command.new "search", "<terms>", "search for something" do |terms|
    include Leafman::Mixin
    title "searching for \"#{terms}\"..."
    pcount = 0
    Leafman::Projects.each do |project|
        unless [project['name'], project['description']||''].collect{|field|field =~ Regexp.new(terms)}.reject{|field|field.nil?}.empty?
            pcount += 1
            list_item project.scm_color+project['name']+"\e[0m"
        end
    end
    log "#{pcount} project#{'s' unless pcount == 1} found."
end
