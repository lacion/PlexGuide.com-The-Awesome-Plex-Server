#!/bin/bash
#
# [Rebuilding Containers]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
docker ps -a --format "{{.Names}}"  > /var/plexguide/container.running

sed -i -e "/traefik/d" /var/plexguide/container.running
sed -i -e "/watchtower/d" /var/plexguide/container.running
sed -i -e "/word*/d" /var/plexguide/container.running
sed -i -e "/plex/d" /var/plexguide/container.running
sed -i -e "/x2go*/d" /var/plexguide/container.running
sed -i -e "/authclient/d" /var/plexguide/container.running

count=$(wc -l < /var/plexguide/container.running)
((count++))
((count--))

echo ""
read -n 1 -s -r -p "We Must Rebuild your Containers! Press [ANY KEY] to Continue!"

for ((i=1; i<$count+1; i++)); do
	app=$(sed "${i}q;d" /var/plexguide/container.running)
	ansible-playbook /opt/plexguide/pg.yml --tags $app --extra-vars "quescheck=off cron=off display=off"
done

echo ""
read -n 1 -s -r -p "Containers Rebuilt! Press [ANY KEY] to Continue!"
echo 'INFO - Rebuilding Complete!' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
