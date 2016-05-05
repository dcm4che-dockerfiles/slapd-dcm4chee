#!/bin/sh

cd /etc/ldap/data/
sed -e "s%dc=dcm4che,dc=org%${LDAP_BASE_DN}%" \
    -e "s%dicomDeviceName=dcm4chee-arc%dicomDeviceName=${DEVICE_NAME}%" \
    -e "s%dicomDeviceName: dcm4chee-arc%dicomDeviceName: ${DEVICE_NAME}%" \
    -e "s%dicomAETitle=DCM4CHEE%dicomAETitle=${AE_TITLE}%" \
    -e "s%dicomAETitle: DCM4CHEE%dicomAETitle: ${AE_TITLE}%" \
    -e "s%dcmRetrieveAET: DCM4CHEE%dcmRetrieveAET: ${AE_TITLE}%" \
    -e "s%archive-host%${ARCHIVE_HOST}%" \
    -e "s%11112%${DICOM_PORT}%" \
    -e "s%2575%${HL7_PORT}%" \
    -e "s%syslog-host%${SYSLOG_HOST}%" \
    -e "s%514%${SYSLOG_PORT}%" \
    -e "s%SYSLOG_UDP%SYSLOG_${SYSLOG_PROTOCOL}%" \
    -e "s%\${jboss.server.data.url}/fs1%file:///${STORAGE_DIR}%" \
    update-${1}.ldif | ldapmodify -xw ${LDAP_ROOTPASS} -D cn=admin,${LDAP_BASE_DN}
