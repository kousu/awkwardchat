# Mattermost Build

Build Mattermost.

Based on [the arch package](https://gitlab.archlinux.org/archlinux/packaging/packages/mattermost.git).

To build, get on an Archlinux system and run:

```
sudo pacman -S base-devel
makepkg -fsr
```

The final build is set up for Arch, and with files arranged following Arch's conventions.
However, being a statically-compiled go app, it will probably work on any Linux system.

To make a version meant for /opt, the way the
[upstream tarballs](https://docs.mattermost.com/deploy/server/deploy-linux.html)
come, additionally run 

 <!-- TODO: make a branch that just builds a /opt version directly -->
```
./repack-opt.sh
````


## Team Edition

If for some reaon you want Team instead of Enterprise edition, compile with `-X "github.com/mattermost/mattermost/server/public/model.BuildEnterpriseReady=false"`.
