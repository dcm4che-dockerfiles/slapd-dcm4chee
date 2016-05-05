FROM dcm4che/slapd:2.4.40

# Default configuration: can be overridden at the docker command line
ENV DEVICE_NAME=dcm4chee-arc \
    AE_TITLE=DCM4CHEE \
    ARCHIVE_HOST=127.0.0.1 \
    DICOM_PORT=11112 \
    HL7_PORT=2575 \
    SYSLOG_HOST=127.0.0.1 \
    SYSLOG_PORT=514 \
    SYSLOG_PROTOCOL=UDP \
    STORAGE_DIR=/opt/wildfly/standalone/data/fs1 \
    SKIP_INIT_CONFIG=false \
    IMPORT_LDIF=

COPY ldap /etc/ldap
COPY bin /usr/bin
