#!/bin/sh

ldapmodify -xw $LDAP_CONFIGPASS -D cn=admin,cn=config -f /etc/ldap/schema/update.ldif
