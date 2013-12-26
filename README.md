hotspot-login
=============
hotspot-login is a ruby script. It goal is connected hotspot like "Sfr Wifi", "FreeWifi" and "UPPA"

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

```
profile:
    :user: USER
    :password: PASSWORD
    :type: sfr or free or uppa...
```

Work with NetworkManager
------------------------

1. Edit /etc/hl.yml
2. Create /etc/NetworkManager/dispatcher.d/hotspot.sh

```
#!/bin/sh
export HOME=/
INTERFACE=$1
STATUS=$2

case "$STATUS" in
    'up') exec /usr/bin/hl.rb;;
esac

```
3. chmod +x /etc/NetworkManager/dispatcher.d/hotspot.sh
