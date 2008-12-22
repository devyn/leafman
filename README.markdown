Leafman
===============
**version _vuhu_**

Leafman is a project manager, particularly useful if you are a freelance hacker like me. After all, I originally developed this just for myself, but then pushed it to Github for everyone to enjoy.

Licensing
-----------------------
All parts of Leafman are licensed under the Creative Commons Attribution Share-alike 3.0 (at <http://creativecommons.org/licenses/by-sa/3.0/>).

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

Web Files
------------------
You can now view the files of a project on the web interface, if web\_show\_files is on. This also allows pulling for Git, Bazaar, and Darcs, but does not allow pulling for Subversion or Mercurial.

    $ git clone http://localhost:8585/<project>.project/files/.git/ <where-to-clone-to> # using git
    $ bzr co http://localhost:8585/<project>.project/files/ <where-to-checkout-to> # using bazaar
    $ darcs get --lazy http://localhost:8585/<project>.project/files/ <where-to-get-to> # using darcs
    
Mercurial is not working because we don't support range requests yet, which static-http on Mercurial needs.

**New!** Easy cloning:

    $ ruby leafman.rb clone <project-name> [host[:port]] # waaay easier

Descriptions
------------------
Now you may add a description to a project, which is shown on "show" and the web interface.

    $ ruby leafman.rb add-description <project-name> # Then type in description and EOF (Ctrl-D on Unix/Mac, Ctrl-Z on Windows)

Tips and Tricks
-------------------
* In place of a project name, most commands support '@@', which means the project that the working directory belongs to.

More coming soon!
