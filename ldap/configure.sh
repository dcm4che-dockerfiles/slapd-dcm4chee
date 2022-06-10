#!/bin/sh

cd /etc/openldap/schema
for f in $LDAP_INIT_SCHEMA; do
    ldapadd -xw $LDAP_CONFIGPASS -D cn=admin,cn=config -H "$LDAP_URLS" -f $f
done

. merge-vendor-data.sh

cd /etc/openldap/data
sed -e "s%dc=dcm4che,dc=org%${LDAP_BASE_DN}%" \
    -e "s%dcm4che.org%${LDAP_ORGANISATION}%" \
    init-baseDN.ldif  | ldapadd -xw $LDAP_ROOTPASS -D cn=admin,${LDAP_BASE_DN} -H "$LDAP_URLS"
if [ "$SKIP_INIT_CONFIG" != "true" ]; then
    if [ -n "$IID_PATIENT_URL" ]; then
      dcmInvokeImageDisplayPatientURL="s%^dcmProperty: IID_PATIENT_URL=%dcmProperty: IID_PATIENT_URL=${IID_PATIENT_URL}%"
    else
      dcmInvokeImageDisplayPatientURL="/^dcmProperty: IID_PATIENT_URL=/d"
    fi
    if [ -n "$IID_STUDY_URL" ]; then
      dcmInvokeImageDisplayStudyURL="s%^dcmProperty: IID_STUDY_URL=%dcmProperty: IID_STUDY_URL=${IID_STUDY_URL}%"
    else
      dcmInvokeImageDisplayStudyURL="/^dcmProperty: IID_STUDY_URL=/d"
    fi
    if [ -n "$IID_URL_TARGET" ]; then
      dcmInvokeImageDisplayURLTarget="s%^dcmProperty: IID_URL_TARGET=%dcmProperty: IID_URL_TARGET=${IID_URL_TARGET}%"
    else
      dcmInvokeImageDisplayURLTarget="/^dcmProperty: IID_URL_TARGET=/d"
    fi
    for f in $LDAP_INIT_CONFIG; do
      cat $f | . ${LDAP_INIT_CONFIG_SED:-sed-init-config} | ldapadd -xw $LDAP_ROOTPASS -D cn=admin,${LDAP_BASE_DN} -H "$LDAP_URLS"
    done
    for f in $LDAP_INIT_USERS; do
        sed -e "s%dc=dcm4che,dc=org%${LDAP_BASE_DN}%" \
            -e "s%uid=user%uid=${AUTH_USER}%" \
            -e "s%uid: user%uid: ${AUTH_USER}%" \
            -e "s%cn=user%cn=${AUTH_USER_ROLE}%" \
            -e "s%cn: user%cn: ${AUTH_USER_ROLE}%" \
            -e "s%uid=admin%uid=${ADMIN_USER}%" \
            -e "s%uid: admin%uid: ${ADMIN_USER}%" \
            -e "s%cn=admin%cn=${ADMIN_USER_ROLE}%" \
            -e "s%cn: admin%cn: ${ADMIN_USER_ROLE}%" \
            -e "s%uid=root%uid=${SUPER_USER}%" \
            -e "s%uid: root%uid: ${SUPER_USER}%" \
            -e "s%cn=root%cn=${SUPER_USER_ROLE}%" \
            -e "s%cn: root%cn: ${SUPER_USER_ROLE}%" \
            $f | ldapadd -xw $LDAP_ROOTPASS -D cn=admin,${LDAP_BASE_DN} -H "$LDAP_URLS"
    done
fi

if [ -n "$IMPORT_LDIF" ]; then
    for f in $IMPORT_LDIF; do
        ldapadd -xw $LDAP_ROOTPASS -D cn=admin,${LDAP_BASE_DN} -H "$LDAP_URLS" -f $f
    done
fi
