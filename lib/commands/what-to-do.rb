Leafman::Command.new "what-to-do", "", "answer the age-old question 'What should I do today?'" do
    include Leafman::Mixin
    puts "\e[1mWhat to do?\e[0m"
    hghst = 0
    Leafman::Projects.each{|p| hghst = p['name'].size if (p['name'].size > hghst) and (p['todos'] or p['bugs']) }
    Leafman::Projects.each do |p|
        p['bugs'].each_with_index do |b, i|
            print "...\e[1m#{p['name']}\e[0m"
            (hghst-p['name'].size+4).times do |tm|
                putc 0x20
            end
            print "\e[36m\e[1mb#{i}: \e[0m"
            puts "\e[31m#{b}\e[0m"
        end if p['bugs']
        p['todos'].each_with_index do |t, i|
            print "...\e[1m#{p['name']}\e[0m"
            (hghst-p['name'].size+4).times do |tm|
                putc 0x20
            end
            print "\e[36m\e[1mt#{i}: \e[0m"
            puts "\e[33m#{t}\e[0m"
        end if p['todos']
    end
end
