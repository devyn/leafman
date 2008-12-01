require 'webrick'
require 'cgi'
module Leafman
    class Servlet < WEBrick::HTTPServlet::AbstractServlet
        STYLESHEET = <<EOF
body {
    font-family: sans-serif;
}
.scm-git, a.scm-git:visited     { color:            #009900; }
.scm-svn, a.scm-svn:visited     { color:            #000099; }
.scm-bzr, a.scm-bzr:visited     { color:            #999900; }
.scm-hg, a.scm-hg:visited       { color:            #009999; }
.scm-darcs, a.scm-darcs:visited { color:            #990099; }
.scm-none, a.scm-none:visited   { color:            #000000; }
.bug                            { color:            #660000; }
.task                           { color:            #666600; }
h1                              { background-color: #999999;
                                  color:            #FFFFFF;
                                  padding-left:     15px;    }
a, a:visited                    { color:            #000000; }
.current-rev                    { color:            #996600; }
EOF
        def do_GET(req,res)
            case req.path
            when '/'
                res['Content-Type'] = 'text/html'
                ps = "<ul>\n"
                Leafman::Projects.each do |p|
                    ps << "<li><a class=\"scm-#{p['scm'] or 'none'}\" href=\"/#{CGI.escape(p['name'])}.project\">#{CGI.escapeHTML(p['name'])}</a></li>\n"
                end
                ps << "</ul>\n"
                res.body = <<EOF
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/styles.css"/>
    <title>Leafman</title>
</head>
<body>
    <h1>Leafman</h1>
    <div>
        <a href="/">home</a>
        <a href="/what-to-do">what to do?</a>
    </div>
    #{ps}
    <hr/>
    <small><em>Powered by Leafman #{Leafman::VERSION}</em></small>
</body>
</html>
EOF
            when '/styles.css'
                res['Content-Type'] = 'text/css'
                res.body = STYLESHEET
            when '/what-to-do'
                res['Content-Type'] = 'text/html'
                ps = "<ul>\n"
                Leafman::Projects.each do |p|
                    p['bugs'].each_with_index do |b, i|
                        ps << "<li><a class='scm-#{p['scm'] or 'none'}' href='/#{CGI.escape(p['name'])}.project'><strong>#{p['name']}</strong></a> "
                        ps << "<strong style='color:#009999'>(b#{i})</strong>: "
                        ps << "<span class='bug'>#{CGI.escapeHTML(b)}</span></li>\n"
                    end if p['bugs']
                    p['todos'].each_with_index do |t, i|
                        ps << "<li><a class='scm-#{p['scm'] or 'none'}' href='/#{CGI.escape(p['name'])}.project'><strong>#{p['name']}</strong></a> "
                        ps << "<strong style='color:#009999'>(t#{i})</strong>: "
                        ps << "<span class='task'>#{CGI.escapeHTML(t)}</span></li>\n"
                    end if p['todos']
                end
                ps << "</ul>\n"
                res.body = <<EOF
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/styles.css"/>
    <title>Leafman - what to do?</title>
</head>
<body>
    <h1>Leafman</h1>
    <div>
        <a href="/">home</a>
        <a href="/what-to-do">what to do?</a>
    </div>
    <h2>what to do?</h2>
    #{ps}
    <hr/>
    <small><em>Powered by Leafman #{Leafman::VERSION}</em></small>
</body>
</html>
EOF
            when /^\/(.+)\.project$/
                p = Leafman::Projects.find($1)
                res['Content-Type'] = 'text/html'
                if p
                    res.body = <<EOF
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/styles.css"/>
    <title>Leafman - project: #{CGI.escapeHTML($1)}</title>
</head>
<body>
    <h1>Leafman</h1>
    <div>
        <a href="/">home</a>
        <a href="/what-to-do">what to do?</a>
    </div>
    <h2>#{CGI.escapeHTML($1)}</h2>
    <div>
        #{"... uses <strong class='scm-git'>Git</strong>#{", pushes" if p['do_push']}#{", syncs with <strong>#{CGI.escapeHTML(p['fetch'])}</strong>" if p['fetch']}." if p['scm'] == 'git'}
        #{"... uses <strong class='scm-svn'>Subversion</strong>#{", pushes" if p['do_push']}#{", syncs" if p['do_update']}." if p['scm'] == 'svn'}
        #{"... uses <strong class='scm-bzr'>Bazaar</strong>#{", pushes" if p['do_push']}#{", syncs" if p['do_update']}." if p['scm'] == 'bzr'}
        #{"... uses <strong class='scm-hg'>Mercurial</strong>#{", pushes" if p['do_push']}#{", syncs" if p['do_pull']}." if p['scm'] == 'hg'}
        #{"... uses <strong class='scm-darcs'>Darcs</strong>#{", pushes" if p['do_push']}#{", syncs" if p['do_pull']}." if p['scm'] == 'darcs'}
        #{"... doesn't use <strong>version control</strong>." unless p['scm']}
    </div>
    <div>
        #{Dir.chdir(p.dir) { "... at revision <strong class='current-rev'>#{`git rev-parse --short HEAD`.chomp}</strong>." } if p['scm'] == 'git'}
        #{Dir.chdir(p.dir) { "... at revision <strong class='current-rev'>#{`svnversion`.chomp}</strong>." } if p['scm'] == 'svn'}
        #{Dir.chdir(p.dir) { "... at revision <strong class='current-rev'>#{`bzr log -r -1`.scan(/^revno: (\d+)$/).flatten.first}</strong>." } if p['scm'] == 'bzr'}
        #{Dir.chdir(p.dir) { "... at revision <strong class='current-rev'>#{`hg identify`.chomp}</strong>." } if p['scm'] == 'hg'}
    </div>
    #{"<div>... is a <strong>#{CGI.escapeHTML(p['type'].capitalize)}</strong> project.</div>" if p['type']}
    #{sss = "<div>\n"
    p['bugs'].each_with_index do |b, i|
        sss << "... <strong class='bug'>bug</strong> (<span style='color:#009999;'>b#{i}</span>): #{CGI.escapeHTML(b)}<br/>\n"
    end if p['bugs']
    sss << "</div>"
    sss if p['bugs']
    }
    #{sss = "<div>\n"
    p['todos'].each_with_index do |b, i|
        sss << "... <strong class='task'>task</strong> (<span style='color:#009999;'>b#{i}</span>): #{CGI.escapeHTML(b)}<br/>\n"
    end if p['todos']
    sss << "</div>"
    sss if p['todos']
    }
    <hr/>
    <small><em>Powered by Leafman #{Leafman::VERSION}</em></small>
</body>
</html>
EOF
                else
                    res.status = 404
                    res.body = "<h1>404 - Project not found</h1>"
                end
            else
                res.status = 404
                res['Content-Type'] = 'text/html'
                res.body = "<h1>404 - Page not found</h1>"
            end
        end
    end
end
