FROM dcm4che/slapd:2.4.44-2

# Default configuration: can be overridden at the docker command line
ENV ARCHIVE_DEVICE_NAME=dcm4chee-arc \
    AE_TITLE=DCM4CHEE \
    ARCHIVE_HOST=127.0.0.1 \
    SCHEDULED_STATION_DEVICE_NAME=scheduledstation \
    SCHEDULED_STATION_AE_TITLE=SCHEDULEDSTATION \
    KEYCLOAK_DEVICE_NAME=keycloak \
    KEYCLOAK_HOST=127.0.0.1 \
    DICOM_PORT=11112 \
    HL7_PORT=2575 \
    SYSLOG_DEVICE_NAME=logstash \
    SYSLOG_HOST=127.0.0.1 \
    SYSLOG_PORT=514 \
    SYSLOG_PROTOCOL=UDP \
    STORAGE_DIR=/opt/wildfly/standalone/data/fs1 \
    ELASTICSEARCH_URL=http://localhost:9200 \
    SKIP_INIT_CONFIG=false \
    EXT_INIT_CONFIG= \
    IMPORT_LDIF=

COPY ldap /etc/ldap
COPY bin /usr/bin

ENV DCM4CHE_VERSION=master \
    DCM4CHEE_ARC_VERSION=master

ENV DCM4CHE_LDAP_SCHEMA_URL=https://raw.githubusercontent.com/dcm4che/dcm4che/$DCM4CHE_VERSION/dcm4che-conf/dcm4che-conf-ldap-schema/src/main/resources/ldap/slapd \
    DCM4CHEE_ARC_LDAP_SCHEMA_URL=https://raw.githubusercontent.com/dcm4che/dcm4chee-arc-light/$DCM4CHEE_ARC_VERSION/dcm4chee-arc-assembly/src/main/resources/ldap/slapd

RUN cd /etc/ldap/schema \
    && curl -fO $DCM4CHE_LDAP_SCHEMA_URL/dicom.ldif \
    && curl -fO $DCM4CHE_LDAP_SCHEMA_URL/dicom-modify.ldif \
    && curl -fO $DCM4CHE_LDAP_SCHEMA_URL/dcm4che.ldif \
    && curl -fO $DCM4CHE_LDAP_SCHEMA_URL/dcm4che-modify.ldif \
    && curl -fO $DCM4CHEE_ARC_LDAP_SCHEMA_URL/dcm4chee-archive.ldif \
    && curl -fO $DCM4CHEE_ARC_LDAP_SCHEMA_URL/dcm4chee-archive-modify.ldif \
    && curl -fO $DCM4CHEE_ARC_LDAP_SCHEMA_URL/dcm4chee-archive-ui.ldif \
    && curl -fO $DCM4CHEE_ARC_LDAP_SCHEMA_URL/dcm4chee-archive-ui-modify.ldif
