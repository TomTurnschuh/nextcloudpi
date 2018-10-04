#!/bin/bash

# Periodically generate previews for the gallery
#
# Copyleft 2018 by Timo Stiefel
# GPL licensed (see end of file) * Use at your own risk!
#

ACTIVE_=no
STARTTIME_=240

DESCRIPTION="Periodically generate previews for the gallery"
INFO="Set the time in minutes after midnight in STARTTIME."

configure()
{
  [[ $ACTIVE_ != "yes" ]] && { 
    rm /etc/cron.d/nc-previews-auto
    service cron restart
    echo "Automatic preview generation disabled"
    return 0
  }
  
  local STARTHOUR STARTMIN TIMEZONEDIFF TIMEZONESIGN HOURZONEDIFF MINZONEDIFF
  
  TIMEZONEDIFF=$(date +"%z")
  TIMEZONESIGN=$TIMEZONEDIFF | head -c 1
  HOURZONEDIFF=$TIMEZONEDIFF | cut -c2-3
  MINZONEDIFF=$TIMEZONEDIFF | cut -c4-5
  
  
  # set crontab
    STARTHOUR=$(( $STARTTIME_ / 60 $TIMEZONESIGN $HOURZONEDIFF ))
    STARTHOUR=$(( $HOUR       % 24  ))
    STARTMIN=$(( $STARTTIME_ % 60 $TIMEZONESIGN $MINZONEDIFF  ))
    STOPHOUR=$((  $STARTHOUR  +  1  ))
    STOPMINS=$((  $STARTMINS        ))
  
  echo "${STARTMINS}  ${STARTHOUR}  *  *  *  root  /usr/bin/sudo -u www-data /usr/bin/php /var/www/nextcloud/occ preview:pre-generate" >  /etc/cron.d/nc-previews-auto
  echo "${STOPMINS}   ${STOPHOUR}   *  *  *  root  /usr/bin/pkill -f \"occ preview\""                                                  >> /etc/cron.d/nc-previews-auto
  service cron restart

  echo "Automatic preview generation enabled"
  return 0
}

install() { :; }

# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA
