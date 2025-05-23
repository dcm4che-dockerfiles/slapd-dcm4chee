FROM dcm4che/slapd:2.6.8

# Default configuration: can be overridden at the docker command line
ENV LDAP_INIT_CMDS=/etc/openldap/configure.sh \
    LDAP_INIT_SCHEMA="dicom.ldif dcm4che.ldif dcm4chee-archive.ldif dcm4chee-archive-ui.ldif" \
    LDAP_UPDATE_SCHEMA="dicom-modify.ldif dcm4che-modify.ldif dcm4chee-archive-modify.ldif dcm4chee-archive-ui-modify.ldif" \
    LDAP_INIT_CONFIG="init-config.ldif dcm4chee-arc.ldif keycloak.ldif logstash.ldif storescp.ldif stowrsd.ldif scheduledstation.ldif add-vendor-data.ldif default-ui-config.ldif" \
    LDAP_INIT_USERS="default-users.ldif" \
    AUTH_USER_ROLE=auth \
    REGULAR_USER=user \
    REGULAR_USER_ROLE=user \
    ADMIN_USER=admin \
    ADMIN_USER_ROLE=admin \
    SUPER_USER=root \
    SUPER_USER_ROLE=root \
    ARCHIVE_DEVICE_NAME=dcm4chee-arc \
    ARCHIVE_WEBAPP_NAME=dcm4chee-arc \
    AE_TITLE=DCM4CHEE \
    AE_TITLE_WORKLIST=WORKLIST \
    AE_TITLE_IOCM_REGULAR_USE=IOCM_REGULAR_USE \
    AE_TITLE_IOCM_QUALITY=IOCM_QUALITY \
    AE_TITLE_IOCM_PAT_SAFETY=IOCM_PAT_SAFETY \
    AE_TITLE_IOCM_WRONG_MWL=IOCM_WRONG_MWL \
    AE_TITLE_IOCM_EXPIRED=IOCM_EXPIRED \
    AE_TITLE_AS_RECEIVED=AS_RECEIVED \
    ARCHIVE_HOST=127.0.0.1 \
    SCHEDULED_STATION_DEVICE_NAME=scheduledstation \
    SCHEDULED_STATION_AE_TITLE=SCHEDULEDSTATION \
    STORESCP_DEVICE_NAME=storescp \
    STORESCP_AE_TITLE=STORESCP \
    STORESCP_HOST=storescp \
    STORESCP_PORT=11117 \
    KEYCLOAK_DEVICE_NAME=keycloak \
    KEYCLOAK_HOST=127.0.0.1 \
    DICOM_PORT=11112 \
    DICOM_TLS_PORT=2762 \
    HL7_PORT=2575 \
    HL7_TLS_PORT=12575 \
    SYSLOG_DEVICE_NAME=logstash \
    SYSLOG_HOST=127.0.0.1 \
    SYSLOG_PORT=514 \
    SYSLOG_PROTOCOL=UDP \
    SYSLOG_TLS_PORT=6514 \
    STORAGE_DIR=/opt/wildfly/standalone/data/fs1

COPY ldap /etc/openldap
COPY bin /usr/bin

RUN cd /etc/openldap/schema && wget -nd \
    https://raw.githubusercontent.com/dcm4che/dcm4che/master/dcm4che-conf/dcm4che-conf-ldap-schema/src/main/resources/ldap/slapd/dicom.ldif \
    https://raw.githubusercontent.com/dcm4che/dcm4che/master/dcm4che-conf/dcm4che-conf-ldap-schema/src/main/resources/ldap/slapd/dicom-modify.ldif \
    https://raw.githubusercontent.com/dcm4che/dcm4che/master/dcm4che-conf/dcm4che-conf-ldap-schema/src/main/resources/ldap/slapd/dcm4che.ldif \
    https://raw.githubusercontent.com/dcm4che/dcm4che/master/dcm4che-conf/dcm4che-conf-ldap-schema/src/main/resources/ldap/slapd/dcm4che-modify.ldif \
    https://raw.githubusercontent.com/dcm4che/dcm4chee-arc-light/master/dcm4chee-arc-assembly/src/main/resources/ldap/slapd/dcm4chee-archive.ldif \
    https://raw.githubusercontent.com/dcm4che/dcm4chee-arc-light/master/dcm4chee-arc-assembly/src/main/resources/ldap/slapd/dcm4chee-archive-modify.ldif \
    https://raw.githubusercontent.com/dcm4che/dcm4chee-arc-light/master/dcm4chee-arc-assembly/src/main/resources/ldap/slapd/dcm4chee-archive-ui.ldif \
    https://raw.githubusercontent.com/dcm4che/dcm4chee-arc-light/master/dcm4chee-arc-assembly/src/main/resources/ldap/slapd/dcm4chee-archive-ui-modify.ldif
