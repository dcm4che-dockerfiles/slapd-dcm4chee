#!/bin/sh

ldapsearch -LL -xw ${LDAP_ROOTPASS} -D cn=admin,${LDAP_BASE_DN} -b cn=DICOM\ Configuration,$LDAP_BASE_DN | unldif.sed
