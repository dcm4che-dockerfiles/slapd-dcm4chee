#!/bin/sh

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dicom.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dcm4che.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dcm4chee-archive.ldif

cd /etc/ldap/data
if [ "$SKIP_INIT_CONFIG" != "true" ]; then
	for f in default-config.ldif add-vendor-data.ldif; do
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
			$f | ldapadd -Y EXTERNAL -H ldapi:///
	done
fi

if [ -n "$IMPORT_LDIF" ]; then
	for f in $IMPORT_LDIF; do
		ldapadd -Y EXTERNAL -H ldapi:/// -f $f
	done
fi