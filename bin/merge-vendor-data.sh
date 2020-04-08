#!/bin/sh

if [ ! -f /etc/openldap/data/vendor-data.zip ]; then
  cp /etc/openldap/data/vendor-data-orig.zip /etc/openldap/data/vendor-data.zip
  if [ -n "$EXT_VENDOR_DATA_PATH" ]; then
    for f in $EXT_VENDOR_DATA_PATH; do
      if [ ! -d $f ]; then
        mkdir /tmp/$f
        unzip $f -d /tmp/$f
        f = /tmp/$f
      fi
      cd $f;
      zip -r /etc/openldap/data/vendor-data.zip .
    done
  done
fi
