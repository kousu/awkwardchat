#!/usr/bin/env bash

set -e
set -x

. PKGBUILD

# unpack Arch packages
pkgdir=`pwd`/pkg/
mkdir -p "${pkgdir}"
ls {mattermost,mmctl}-${pkgver}-${pkgrel}-*.pkg.tar.zst | xargs -n 1 tar --zstd -C pkg -xvf

# rearrange into /opt
opt=`pwd`/opt/mattermost
mkdir -p "${opt}"

cp -rp ${pkgdir}/usr/share/webapps/mattermost/* ${opt}/
find ${opt} -type l -delete
cp -rp ${pkgdir}/usr/bin ${opt}/
cp -rp ${pkgdir}/var/lib/mattermost/client/ ${opt}/  # arch moved some of the client code around
cp -rpT ${pkgdir}/etc/webapps/mattermost ${opt}/config # notice -T
cp ${pkgdir}/usr/share/doc/mattermost/* ${opt}/
cp ${pkgdir}/usr/share/licenses/mattermost/* ${opt}/
mkdir -p ${opt}/logs

# Undo some of the edits the PKGBUILD did
mv ${opt}/config/{default,config.defaults}.json
sed -i -e 's/^  /    /g' ${opt}/config/config.json
sed -i -e 's/^  /    /g' ${opt}/config/config.json

jq '.FileSettings.Directory |= "./data/" | # \
    .ComplianceSettings.Directory |= "./data/" | # \
    .PluginSettings.Directory |= "./plugins" | # \
    .PluginSettings.ClientDirectory |= "./client/plugins" | # \
    .LogSettings.FileLocation |= "" | # \
    .NotificationLogSettings.FileLocation |= ""' \
  ${opt}/config/config.json > config-new.json
mv config-new.json ${opt}/config/config.json


# repack
tar -C opt/ -zcvf mattermost-${pkgver}-$(uname)-$(uname -m).tar.gz .


