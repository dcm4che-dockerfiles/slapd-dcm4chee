FROM dcm4che/slapd:2.4.48

# Default configuration: can be overridden at the docker command line
ENV ARCHIVE_DEVICE_NAME=dcm4chee-arc \
    ARCHIVE_WEBAPP_NAME=dcm4chee-arc \
    AE_TITLE=DCM4CHEE \
    AE_TITLE_IOCM_REGULAR_USE=IOCM_REGULAR_USE \
    AE_TITLE_IOCM_QUALITY=IOCM_QUALITY \
    AE_TITLE_IOCM_PAT_SAFETY=IOCM_PAT_SAFETY \
    AE_TITLE_IOCM_WRONG_MWL=IOCM_WRONG_MWL \
    AE_TITLE_IOCM_EXPIRED=IOCM_EXPIRED \
    AE_TITLE_AS_RECEIVED=AS_RECEIVED \
    ARCHIVE_HOST=127.0.0.1 \
    SCHEDULED_STATION_DEVICE_NAME=scheduledstation \
    SCHEDULED_STATION_AE_TITLE=SCHEDULEDSTATION \
    KEYCLOAK_DEVICE_NAME=keycloak \
    KEYCLOAK_HOST=127.0.0.1 \
    AUTH_SERVER_URL=http://keycloak:8080/auth \
    REALM_NAME=dcm4che \
    KEYCLOAK_CLIENT_ID=dcm4chee-arc-ui \
    DICOM_PORT=11112 \
    HL7_PORT=2575 \
    SYSLOG_DEVICE_NAME=logstash \
    SYSLOG_HOST=127.0.0.1 \
    SYSLOG_PORT=514 \
    SYSLOG_PROTOCOL=UDP \
    SYSLOG_TLS_PORT=6514 \
    STORAGE_DIR=/opt/wildfly/standalone/data/fs1 \
    ELASTICSEARCH_URL=http://localhost:9200 \
    SKIP_INIT_CONFIG=false \
    EXT_INIT_CONFIG= \
    IMPORT_LDIF=

COPY ldap /etc/openldap
COPY bin /usr/bin

ENV DCM4CHE_VERSION=master \
    DCM4CHEE_ARC_VERSION=master

ENV DCM4CHE_LDAP_SCHEMA_URL=https://raw.githubusercontent.com/dcm4che/dcm4che/$DCM4CHE_VERSION/dcm4che-conf/dcm4che-conf-ldap-schema/src/main/resources/ldap/slapd \
    DCM4CHEE_ARC_LDAP_SCHEMA_URL=https://raw.githubusercontent.com/dcm4che/dcm4chee-arc-light/$DCM4CHEE_ARC_VERSION/dcm4chee-arc-assembly/src/main/resources/ldap/slapd

RUN cd /etc/openldap/schema && wget -nd \
    $DCM4CHE_LDAP_SCHEMA_URL/dicom.ldif \
    $DCM4CHE_LDAP_SCHEMA_URL/dicom-modify.ldif \
    $DCM4CHE_LDAP_SCHEMA_URL/dcm4che.ldif \
    $DCM4CHE_LDAP_SCHEMA_URL/dcm4che-modify.ldif \
    $DCM4CHEE_ARC_LDAP_SCHEMA_URL/dcm4chee-archive.ldif \
    $DCM4CHEE_ARC_LDAP_SCHEMA_URL/dcm4chee-archive-modify.ldif \
    $DCM4CHEE_ARC_LDAP_SCHEMA_URL/dcm4chee-archive-ui.ldif \
    $DCM4CHEE_ARC_LDAP_SCHEMA_URL/dcm4chee-archive-ui-modify.ldif
