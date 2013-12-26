hotspot-login
=============
hotspot-login is a ruby script. It goal is connect hotspot likes "Sfr Wifi", "FreeWifi" and "UPPA"

Install
-------
gem install hotspot-login

Use
----
*Help* hl.rb --help
*Automatic connection (use: ~/.config/hl.yml)* hl.rb
*Manual connection* hl.rb --hotspot HOTSPOT --user USER --password PASSWORD

Configuration
-------------
*Edit ~/.config/hl.yml*

profile:
    user: USER
    password: PASSWORD
    hotspot: sfr or free or uppa...
