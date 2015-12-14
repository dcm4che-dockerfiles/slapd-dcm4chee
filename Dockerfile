FROM dcm4che/slapd:2.4.40

# Default configuration: can be overridden at the docker command line
ENV DEVICE_NAME=dcm4chee-arc \
    AE_TITLE=DCM4CHEE \
    DICOM_HOST=localhost \
    DICOM_PORT=11112 \
    HL7_PORT=2575 \
    STORAGE_DIR=/var/local/dcm4chee-arc/fs1/ \
    SKIP_INIT_CONFIG=false \
    IMPORT_LDIF=

COPY ldap /etc/ldap
