#!/bin/bash
set -e
plugin_dir=/usr/share/jenkins/ref/plugins/
file_owner=jenkins.jenkins


echo "Installing plugins into JENKINS_HOME_PLUGINS: $plugin_dir"
mkdir -p "$plugin_dir"

installPlugin() {
  #  this is a test to see if the file exists
  if [ -f "${plugin_dir}/${1}.hpi" ] || [ -f "${plugin_dir}/${1}.jpi" ]; then
    if [ "$2" == "1" ]; then
      echo "Found ${plugin_dir}/${1}.jpi"
    # debug  "echo  ${plugin_dir}/${1}.hpi does not exist"
      return 1
    fi
    echo "Skipped: $1 (already installed)"
    return 0
  else
    # first make sure the file is there if not it's a 404 and we need to skip or report an error
    # debug echo "Checking existance of file on server"
    #code=$(curl -s -o /dev/null -I -w "%{http_code}" "${plugin_dir}/${1}.hpi")
    #if [ "$code" == "404" ]; then echo "file ${1} doesn't exist" return 1; fi

    echo "Downloading: $1"
    curl  --retry 5 --retry-delay 3 -s -f -L --output "${plugin_dir}/${1}.hpi"  "https://updates.jenkins-ci.org/latest/${1}.hpi"
    return 0
  fi
}

#for plugin in $*
for plugin in $(cat "$1")
do
    installPlugin "$plugin"
done

changed=1
maxloops=100

while [ "$changed"  == "1" ]; do
  echo "Check for missing dependecies ..."
  if  [ $maxloops -lt 1 ] ; then
    echo "Max loop count reached - probably a bug in this script: $0"
    exit 1
  fi
  ((maxloops--))
  changed=0
  ###
  ### I appologize for the subsituation string.  It's a nightmare basically we unzip the just the MAN
  ### file and turn everything into one long line then parse out the dependencies and optional dependcies
  ### without the version number.
  ###
  for f in ${plugin_dir}/*.hpi ; do
    echo "Checking dependecies in $f plugin"
    deps=$( unzip -p "${f}" META-INF/MANIFEST.MF | tr -d '\r'| tr -d '\n' | tr -d ' ' | sed -n 's/.*Plugin-Dependencies:\(.*\)Plugin-Developers.*/\1/p' | tr ';' '\n' | sed 's/resolution:=optional//g' | sed 's/^,//g' | tr ',' '\n'| sed 's/:.*$//g')
    # check to see if there is anything in the $deps var
    echo "dependencies: $deps"
      echo -e "Found dependencies: \n$deps "
      for plugin in $deps; do
        set -x
        installPlugin "$plugin" 1 && changed=1
        set +x
      done
  done
done

echo "fixing permissions"

chown ${file_owner} ${plugin_dir} -R

echo "all done"
