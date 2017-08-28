This docker image provides LDAP Server initalized for the DICOM Archive
[dcm4chee-arc-light](https://github.com/dcm4che/dcm4chee-arc-light/wiki).
It extends the [dcm4che slapd image](https://hub.docker.com/r/dcm4che/slapd/).

# How to use this image

## start a slapd instance

```console
$ docker run --name slapd \
             -p 389:389 \
             -v /var/local/dcm4chee-arc/ldap:/var/lib/ldap \
             -v /var/local/dcm4chee-arc/slapd.d:/etc/ldap/slapd.d \
             -d dcm4che/slapd-dcm4chee:2.4.44-10.5
```

## Environment Variables

Below explained environment variables can be set as per one's application to override the default values if need be.
An example of how one can set an env variable in `docker run` command is shown below :

    -e LDAP_ROOTPASS=mypass

### `LDAP_BASE_DN`

This environment variable sets the base domain name for LDAP. Default value is "dc=dcm4che,dc=org".

### `LDAP_ORGANISATION`

This environment variable sets the organisation name for LDAP. Default value is "dcm4che.org".

### `LDAP_ROOTPASS`

This environment variable sets the root password for LDAP. Default value is "secret".

### `LDAP_CONFIGPASS`

This environment variable sets the password for users who wish to change the schema configuration in LDAP. 
Default value is "secret".

### `ARCHIVE_DEVICE_NAME`

This is the name of archive device. Default value is "dcm4chee-arc".

### `AE_TITLE`

This is the name of Application Entity title of archive device. Default value is "DCM4CHEE".

### `DICOM_HOST`

This is the hostname of DICOM connection in archive device. The DICOM connection is referenced by the application entities 
of the archive. Default value is "dockerhost".

### `DICOM_PORT`

This is the port number of DICOM connection in archive device. The DICOM connection is referenced by the application entities 
of the archive. Default value is "11112".

### `HL7_PORT`

This is the port number of HL7 connection in archive device. The HL7 connection is referenced by the hl7Application of 
archive device. Default value is "2575".

### `SYSLOG_DEVICE_NAME`

This is the name of device used as audit record repository. Archive device emits audit messages to this device if 
audit logging is enabled. Default value is "logstash". 

### `SYSLOG_HOST`

This is the hostname of device used as audit record repository. Archive device emits audit messages to this device if 
audit logging is enabled. Default value is "127.0.0.1". 

### `SYSLOG_PORT`

This is the port number of device used as audit record repository. Archive device emits audit messages to this device if 
audit logging is enabled. Default value is "8514". 

### `SYSLOG_PROTOCOL`

This is the protocol set to device used as audit record repository. Archive device emits audit messages to this device if 
audit logging is enabled. Default value is "UDP". 

### `KEYCLOAK_DEVICE_NAME`

This is the name of keycloak device used in conjunction with the emission of audit messages for authentication events of 
secured version of archive. Default value is "keycloak". 

### `SCHEDULED_STATION_DEVICE_NAME`

This is the name of the device referenced in default scheduled station configured in the archive device which is used  as 
a fallback option for populating the Scheduled Station AE title in the Modality Worklist attributes when HL7 order messages 
are received by the archive. Default value is "scheduledstation". 

### `SCHEDULED_STATION_AE_TITLE`

This is the Application Entity title of the device referenced in default scheduled station configured in the archive device which is used  as 
a fallback option for populating the Scheduled Station AE title in the Modality Worklist attributes when HL7 order messages 
are received by the archive. Default value is "SCHEDULEDSTATION". 

### `STORAGE_DIR`

This is the URI of the storage location where the objects of a study will be stored when studies are sent to the archive.
Default value is "/storage/fs1". 


