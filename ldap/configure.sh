#!/bin/bash

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dicom.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dcm4che.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dcm4chee-archive.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dcm4chee-archive-ui.ldif

cd /etc/ldap/data
if [ "$SKIP_INIT_CONFIG" != "true" ]; then
    for f in default-config.ldif add-vendor-data.ldif init-ui-config.ldif default-ui-config.ldif default-users.ldif $EXT_INIT_CONFIG; do
        sed -e "s%dc=dcm4che,dc=org%${LDAP_BASE_DN}%" \
            -e "s%dicomDeviceName=dcm4chee-arc%dicomDeviceName=${ARCHIVE_DEVICE_NAME}%" \
            -e "s%^dicomDeviceName: dcm4chee-arc%dicomDeviceName: ${ARCHIVE_DEVICE_NAME}%" \
            -e "s%dicomAETitle=DCM4CHEE%dicomAETitle=${AE_TITLE}%" \
            -e "s%^dicomAETitle: DCM4CHEE%dicomAETitle: ${AE_TITLE}%" \
            -e "s%^dcmRetrieveAET: DCM4CHEE%dcmRetrieveAET: ${AE_TITLE}%" \
            -e "s%^dcmStorageVerificationAETitle: DCM4CHEE%dcmStorageVerificationAETitle: ${AE_TITLE}%" \
            -e "s%^dcmCompressionAETitle: DCM4CHEE%dcmCompressionAETitle: ${AE_TITLE}%" \
            -e "s%^dcmXDSiImagingDocumentSourceAETitle: DCM4CHEE%dcmXDSiImagingDocumentSourceAETitle: ${AE_TITLE}%" \
            -e "s%^dcmRejectExpiredStudiesAETitle: DCM4CHEE%dcmRejectExpiredStudiesAETitle: ${AE_TITLE}%" \
            -e "s%^dcmRejectionNoteStorageAET: DCM4CHEE%dcmRejectionNoteStorageAET: ${AE_TITLE}%" \
            -e "s%^dcmAuditUserID: DCM4CHEE%dcmAuditUserID: ${AE_TITLE}%" \
            -e "s%^dcmuiCountAET: DCM4CHEE%dcmuiCountAET: ${AE_TITLE}%" \
            -e "s%dicomAETitle=IOCM_REGULAR_USE%dicomAETitle=${AE_TITLE_IOCM_REGULAR_USE}%" \
            -e "s%^dicomAETitle: IOCM_REGULAR_USE%dicomAETitle: ${AE_TITLE_IOCM_REGULAR_USE}%" \
            -e "s%dicomAETitle=IOCM_QUALITY%dicomAETitle=${AE_TITLE_IOCM_QUALITY}%" \
            -e "s%^dicomAETitle: IOCM_QUALITY%dicomAETitle: ${AE_TITLE_IOCM_QUALITY}%" \
            -e "s%dicomAETitle=IOCM_PAT_SAFETY%dicomAETitle=${AE_TITLE_IOCM_PAT_SAFETY}%" \
            -e "s%^dicomAETitle: IOCM_PAT_SAFETY%dicomAETitle: ${AE_TITLE_IOCM_PAT_SAFETY}%" \
            -e "s%dicomAETitle=IOCM_WRONG_MWL%dicomAETitle=${AE_TITLE_IOCM_WRONG_MWL}%" \
            -e "s%^dicomAETitle: IOCM_WRONG_MWL%dicomAETitle: ${AE_TITLE_IOCM_WRONG_MWL}%" \
            -e "s%dicomAETitle=IOCM_EXPIRED%dicomAETitle=${AE_TITLE_IOCM_EXPIRED}%" \
            -e "s%^dicomAETitle: IOCM_EXPIRED%dicomAETitle: ${AE_TITLE_IOCM_EXPIRED}%" \
            -e "s%dicomAETitle=AS_RECEIVED%dicomAETitle=${AE_TITLE_AS_RECEIVED}%" \
            -e "s%^dicomAETitle: AS_RECEIVED%dicomAETitle: ${AE_TITLE_AS_RECEIVED}%" \
            -e "s%dcmWebAppName=dcm4chee-arc%dcmWebAppName=${ARCHIVE_WEBAPP_NAME}%" \
            -e "s%^dcmWebAppName: dcm4chee-arc%dcmWebAppName: ${ARCHIVE_WEBAPP_NAME}%" \
            -e "s%dcmWebAppName=DCM4CHEE%dcmWebAppName=${AE_TITLE}%" \
            -e "s%^dcmWebAppName: DCM4CHEE%dcmWebAppName: ${AE_TITLE}%" \
            -e "s%^dcmWebServicePath: /dcm4chee-arc/aets/DCM4CHEE%dcmWebServicePath: /dcm4chee-arc/aets/${AE_TITLE}%" \
            -e "s%dcmWebAppName=IOCM_REGULAR_USE%dcmWebAppName=${AE_TITLE_IOCM_REGULAR_USE}%" \
            -e "s%^dcmWebAppName: IOCM_REGULAR_USE%dcmWebAppName: ${AE_TITLE_IOCM_REGULAR_USE}%" \
            -e "s%^dcmWebServicePath: /dcm4chee-arc/aets/IOCM_REGULAR_USE%dcmWebServicePath: /dcm4chee-arc/aets/${AE_TITLE_IOCM_REGULAR_USE}%" \
            -e "s%dcmWebAppName=IOCM_QUALITY%dcmWebAppName=${AE_TITLE_IOCM_QUALITY}%" \
            -e "s%^dcmWebAppName: IOCM_QUALITY%dcmWebAppName: ${AE_TITLE_IOCM_QUALITY}%" \
            -e "s%^dcmWebServicePath: /dcm4chee-arc/aets/IOCM_QUALITY%dcmWebServicePath: /dcm4chee-arc/aets/${AE_TITLE_IOCM_QUALITY}%" \
            -e "s%dcmWebAppName=IOCM_PAT_SAFETY%dcmWebAppName=${AE_TITLE_IOCM_PAT_SAFETY}%" \
            -e "s%^dcmWebAppName: IOCM_PAT_SAFETY%dcmWebAppName: ${AE_TITLE_IOCM_PAT_SAFETY}%" \
            -e "s%^dcmWebServicePath: /dcm4chee-arc/aets/IOCM_PAT_SAFETY%dcmWebServicePath: /dcm4chee-arc/aets/${AE_TITLE_IOCM_PAT_SAFETY}%" \
            -e "s%dcmWebAppName=IOCM_WRONG_MWL%dcmWebAppName=${AE_TITLE_IOCM_WRONG_MWL}%" \
            -e "s%^dcmWebAppName: IOCM_WRONG_MWL%dcmWebAppName: ${AE_TITLE_IOCM_WRONG_MWL}%" \
            -e "s%^dcmWebServicePath: /dcm4chee-arc/aets/IOCM_WRONG_MWL%dcmWebServicePath: /dcm4chee-arc/aets/${AE_TITLE_IOCM_WRONG_MWL}%" \
            -e "s%dcmWebAppName=IOCM_EXPIRED%dcmWebAppName=${AE_TITLE_IOCM_EXPIRED}%" \
            -e "s%^dcmWebAppName: IOCM_EXPIRED%dcmWebAppName: ${AE_TITLE_IOCM_EXPIRED}%" \
            -e "s%^dcmWebServicePath: /dcm4chee-arc/aets/IOCM_EXPIRED%dcmWebServicePath: /dcm4chee-arc/aets/${AE_TITLE_IOCM_EXPIRED}%" \
            -e "s%dcmWebAppName=AS_RECEIVED%dcmWebAppName=${AE_TITLE_AS_RECEIVED}%" \
            -e "s%^dcmWebAppName: AS_RECEIVED%dcmWebAppName: ${AE_TITLE_AS_RECEIVED}%" \
            -e "s%^dcmWebServicePath: /dcm4chee-arc/aets/AS_RECEIVED%dcmWebServicePath: /dcm4chee-arc/aets/${AE_TITLE_AS_RECEIVED}%" \
            -e "s%archive-host%${ARCHIVE_HOST}%" \
            -e "s%dicomDeviceName=scheduledstation%dicomDeviceName=${SCHEDULED_STATION_DEVICE_NAME}%" \
            -e "s%^dicomDeviceName: scheduledstation%dicomDeviceName: ${SCHEDULED_STATION_DEVICE_NAME}%" \
            -e "s%dicomAETitle=SCHEDULEDSTATION%dicomAETitle=${SCHEDULED_STATION_AE_TITLE}%" \
            -e "s%^dicomAETitle: SCHEDULEDSTATION%dicomAETitle: ${SCHEDULED_STATION_AE_TITLE}%" \
            -e "s%dicomDeviceName=keycloak%dicomDeviceName=${KEYCLOAK_DEVICE_NAME}%" \
            -e "s%^dicomDeviceName: keycloak%dicomDeviceName: ${KEYCLOAK_DEVICE_NAME}%" \
            -e "s%keycloak-host%${KEYCLOAK_HOST}%" \
            -e "s%11112%${DICOM_PORT}%" \
            -e "s%2575%${HL7_PORT}%" \
            -e "s%dicomDeviceName=logstash%dicomDeviceName=${SYSLOG_DEVICE_NAME}%" \
            -e "s%^dicomDeviceName: logstash%dicomDeviceName: ${SYSLOG_DEVICE_NAME}%" \
            -e "s%syslog-host%${SYSLOG_HOST}%" \
            -e "s%514%${SYSLOG_PORT}%" \
            -e "s%SYSLOG_UDP%SYSLOG_${SYSLOG_PROTOCOL}%" \
            -e "s%\${jboss.server.data.url}/fs1%file://${STORAGE_DIR}%" \
            -e "s%^dcmuiElasticsearchURL: http://localhost:9200%dcmuiElasticsearchURL: ${ELASTICSEARCH_URL}%" \
            $f | ldapadd -Y EXTERNAL -H ldapi:///
    done
fi

if [ -n "$IMPORT_LDIF" ]; then
    for f in $IMPORT_LDIF; do
        ldapadd -Y EXTERNAL -H ldapi:/// -f $f
    done
fi
