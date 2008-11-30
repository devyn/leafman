Leafman
===============
Leafman is a project manager, particularly useful if you are a freelance hacker like me. After all, I originally developed this just for myself, but then pushed it to Github for everyone to enjoy.

Repository Support
-----------------------
* Git (green)
* Subversion (blue)
* Bazaar (yellow)
* Mercurial (cyan)
* Darcs (purple)

I have no intention of supporting CVS, it's just too outdated for me.

Examples
--------------------
    $ ruby leafman.rb create|destroy "project"
This will create/destroy a project.

    $ ruby leafman.rb list
This gives you a list of all projects.

    $ ruby leafman.rb show "project"
This shows detailed information on a project.

Also, really useful:

    $ ruby leafman.rb help
for all commands.

Web Interface
-------------------
A relatively new feature to Leafman is the ability to serve a web page with all projects. This is useful if, for example, you are on a large LAN and want to share projects. To start it:

    $ ruby leafman.rb serve
Then, go to <http://localhost:8585>.

Also, to note: most colors on the web interface are the same as they are on the console interface. (eg. for scm colors, bug/task colors, etc.)
