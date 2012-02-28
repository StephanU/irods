#!/bin/bash

# =-=-=-=-=-=-=-
# stop any running E-iRODS Processes
echo "*** Running Pre-Remove Script ***"
echo "Stopping iRODS :: $1/irodsctl stop"
sudo -u $2 $1/irodsctl stop

# =-=-=-=-=-=-=-
# determine if the database already exists
DB=$(sudo -u $3 psql --list  | grep $4 )
if [ -n "$DB" ]; then
  echo "Removing Database $4"
  sudo -u $3 dropdb $4
fi

# =-=-=-=-=-=-=-
# determine if the database role already exists
ROLE=$(sudo -u $3 psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$2'")
if [ $ROLE ]; then
  echo "Removing Database Role $2"
  sudo -u $3 dropuser $2
fi

# =-=-=-=-=-=-=-
# determine if the service account already exists
USER=$( grep $2 /etc/passwd )
if [ -n "$USER" ]; then 
  echo "Removing Service Account $2"
  deluser $2
fi

# =-=-=-=-=-=-=-
# remove runlevel symlinks
rm /etc/init.d/e-irods
rm /etc/rc0.d/K15e-irods
rm /etc/rc2.d/S95e-irods
rm /etc/rc3.d/S95e-irods
rm /etc/rc4.d/S95e-irods
rm /etc/rc5.d/S95e-irods
rm /etc/rc6.d/K15e-irods

# =-=-=-=-=-=-=-
# remove irodsctl and icommands symlinks
rm /usr/bin/irodsctl
rm /usr/bin/genOSAuth
rm /usr/bin/iadmin
rm /usr/bin/ibun
rm /usr/bin/icd
rm /usr/bin/ichksum
rm /usr/bin/ichmod
rm /usr/bin/icp
rm /usr/bin/idbo
rm /usr/bin/idbug
rm /usr/bin/ienv
rm /usr/bin/ierror
rm /usr/bin/iexecmd
rm /usr/bin/iexit
rm /usr/bin/ifsck
rm /usr/bin/iget
rm /usr/bin/igetwild.sh
rm /usr/bin/ihelp
rm /usr/bin/iinit
rm /usr/bin/ilocate
rm /usr/bin/ils
rm /usr/bin/ilsresc
rm /usr/bin/imcoll
rm /usr/bin/imeta
rm /usr/bin/imiscsvrinfo
rm /usr/bin/imkdir
rm /usr/bin/imv
rm /usr/bin/ipasswd
rm /usr/bin/iphybun
rm /usr/bin/iphymv
rm /usr/bin/ips
rm /usr/bin/iput
rm /usr/bin/ipwd
rm /usr/bin/iqdel
rm /usr/bin/iqmod
rm /usr/bin/iqstat
rm /usr/bin/iquest
rm /usr/bin/iquota
rm /usr/bin/ireg
rm /usr/bin/irepl
rm /usr/bin/irm
rm /usr/bin/irmtrash
rm /usr/bin/irsync
rm /usr/bin/irule
rm /usr/bin/iscan
rm /usr/bin/isysmeta
rm /usr/bin/itrim
rm /usr/bin/iuserinfo
rm /usr/bin/ixmsg

# =-=-=-=-=-=-=-
# exit with success
exit 0