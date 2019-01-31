#!/usr/bin/bash

docker pull registry.access.redhat.com/rhel7:latest

if [[ "$?" -eq 0 ]]; then
  echo "Found Rhel in dri registry. using"
  docker tag dc1-dck-preg01.global.ldap.wan/dripublic/rhel:latest r7base
  exit 0
fi

echo "Trying centos"
docker pull centos:7

if [[ "$?" -eq 0 ]]; then
  echo "Found centos. Using"
  docker tag centos:7 r7base
  exit 0
fi

echo "No suitable images found. Exiting."
exit 1
