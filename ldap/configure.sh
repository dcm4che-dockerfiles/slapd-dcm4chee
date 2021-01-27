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
        sed -e "${dcmInvokeImageDisplayPatientURL}" \
            -e "${dcmInvokeImageDisplayStudyURL}" \
            -e "${dcmInvokeImageDisplayURLTarget}" \
            -e "s%dc=dcm4che,dc=org%${LDAP_BASE_DN}%" \
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
            -e "s%dicomPort: 11112%dicomPort: ${DICOM_PORT}%" \
            -e "s%dicomPort: 2762%dicomPort: ${DICOM_TLS_PORT}%" \
            -e "s%dicomPort: 2575%dicomPort: ${HL7_PORT}%" \
            -e "s%dicomPort: 12575%dicomPort: ${HL7_TLS_PORT}%" \
            -e "s%dicomDeviceName=logstash%dicomDeviceName=${SYSLOG_DEVICE_NAME}%" \
            -e "s%^dicomDeviceName: logstash%dicomDeviceName: ${SYSLOG_DEVICE_NAME}%" \
            -e "s%syslog-host%${SYSLOG_HOST}%" \
            -e "s%^dicomPort: 514%dicomPort: ${SYSLOG_PORT}%" \
            -e "s%^dicomPort: 6514%dicomPort: ${SYSLOG_TLS_PORT}%" \
            -e "s%SYSLOG_UDP%SYSLOG_${SYSLOG_PROTOCOL}%" \
            -e "s%\${jboss.server.data.url}/fs1%file://${STORAGE_DIR}%" \
            $f | ldapadd -xw $LDAP_ROOTPASS -D cn=admin,${LDAP_BASE_DN} -H "$LDAP_URLS"
    done
fi

if [ -n "$IMPORT_LDIF" ]; then
    for f in $IMPORT_LDIF; do
        ldapadd -xw $LDAP_ROOTPASS -D cn=admin,${LDAP_BASE_DN} -H "$LDAP_URLS" -f $f
    done
fi
