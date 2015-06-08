DBUSER="root"
DBPASS="cubs1908"
SITEDIR="/var/www/povertylaw.org/"
CONFIGDIR=`pwd`
CIVIVERSION="4.4.15"
#CIVIVERSION="4.2.9"
CIVITARBALL="civicrm-${CIVIVERSION}-drupal6.tar.gz"
rm ${CIVITARBALL}
wget -nc http://sourceforge.net/projects/civicrm/files/civicrm-stable/${CIVIVERSION}/${CIVITARBALL}/download -O ${CIVITARBALL}
cp ${CIVITARBALL} ${SITEDIR}/sites/all/modules/.
echo "cp ${CIVITARBALL} ${SITEDIR}/sites/all/modules/."
ls -al ${SITEDIR}/sites/all/modules/${CIVITARBALL}
pushd ${SITEDIR}/sites/all/modules
drush pml --pipe --status=enabled | grep civicrm > ${CONFIGDIR}/modules.civicrm.list
cat ${CONFIGDIR}/modules.civicrm.list | xargs -L 1 drush dis -y
rm -rf civicrm
tar xfz ${CIVITARBALL}
echo "tar xfz ${CIVITARBALL}"
popd

pushd ${SITEDIR}
drush en -y civicrm
#FIXME might be too slow to enable debug during upgrade that will proceed smoothly, take out if slows down upgrade
mkdir ${CONFIGDIR}/oldlogs
mkdir ${CONFIGDIR}/logs
cp /var/www/povertylaw.org/sites/default/files/civicrm/ConfigAndLog/* oldlogs/.
drush -y civicrm-enable-debug
drush -y civicrm-upgrade-db
cp /var/www/povertylaw.org/sites/default/files/civicrm/ConfigAndLog/* logs/.
drush cc -y all
chmod uog+rxw -R sites/default/files/
rm -rf sites/default/files/civicrm/templates_c
rm -rf sites/default/files/civicrm/ConfigAndLog
drush cc -y all
chmod uog+rxw -R /var/www/povertylaw.org/sites/default/files/civicrm
