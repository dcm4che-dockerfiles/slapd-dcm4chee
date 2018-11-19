This docker image provides LDAP Server initalized for the DICOM Archive
[dcm4chee-arc-light](https://github.com/dcm4che/dcm4chee-arc-light/wiki).
It extends the [dcm4che slapd image](https://hub.docker.com/r/dcm4che/slapd/).

# How to use this image

## start a slapd instance

```
$ docker run --name slapd \
             -p 389:389 \
             -v /etc/localtime:/etc/localtime \
             -v /var/local/dcm4chee-arc/ldap:/var/lib/ldap \
             -v /var/local/dcm4chee-arc/slapd.d:/etc/ldap/slapd.d \
             -d dcm4che/slapd-dcm4chee:2.4.44-14.1
```

## Environment Variables

Below explained environment variables can be set as per one's application to override the default values if need be.
An example of how one can set an env variable in `docker run` command is shown below :

    -e LDAP_ROOTPASS=mypass

### `LDAP_BASE_DN`

This environment variable sets the base domain name for LDAP. Default value is `dc=dcm4che,dc=org`.

### `LDAP_ORGANISATION`

This environment variable sets the organisation name for LDAP. Default value is `dcm4che.org`.

### `LDAP_ROOTPASS`

This environment variable sets the root password for accessing the LDAP data with bind DN `cn=admin,${LDAP_BASE_DN}`.
Only effective if the file specified by `LDAP_ROOTPASS_FILE` does not exist. Default value is `secret`.

### `LDAP_ROOTPASS_FILE`

Path to file containing the root password for accessing the LDAP data with bind DN `cn=admin,${LDAP_BASE_DN}`. 
If the file does not exist, it will be created containing the password specified by `LDAP_ROOTPASS`. 
Default value is `/tmp/ldap_rootpass`.

### `LDAP_CONFIGPASS`

This environment variable sets the password for accessing the slapd configuration with bind DN `cn=config`. 
Only effective if the file specified by `LDAP_CONFIGPASS_FILE` does not exist. Default value is `secret`.

### `LDAP_CONFIGPASS_FILE`

Path to file containing the password for accessing the slapd configuration with bind DN `cn=config`. 
If the file does not exist, it will be created containing the password specified by `LDAP_CONFIGPASS`. 
Default value is `/tmp/ldap_configpass`.

### `LDAP_URLS`

Space separated list of LDAP URLs to serve.
Set to `"ldap:///"` by default (LDAP over TCP on all interfaces on default LDAP port).
The default `ldap://` port is `389` and the default `ldaps://` port is `636`.

### `LDAP_TLS_CACERT`

This environment variable specifies the PEM-format file containing certificates for the CA's that slapd will trust.
The certificate for the CA that signed the server certificate must be included among these certificates. If the
signing CA was not a top-level (root) CA, certificates for the entire sequence of CA's from the signing CA to the
top-level CA should be present. Multiple certificates are simply appended to the file; the order is not significant.
Default value is `/etc/certs/cacert.pem`.

### `LDAP_TLS_CERT`

This environment variable specifies the file that contains the slapd server certificate. The DN of a server certificate
shall use the CN attribute to name the server, and the CN shall carry the server's fully qualified domain name.
Additional alias names and wildcards may be present in the subjectAltName certificate extension. Default value is
`/etc/certs/cert.pem`.

### `LDAP_TLS_KEY`

This environment variable specifies the file that contains the private key that matches the certificate stored in the
`LDAP_TLS_CERT` file. Default value is `/etc/certs/key.pem`.

### `LDAP_TLS_VERIFY`

This environment variable specifies what checks to perform on client certificates in an incoming TLS session, if any.
This option is set to `never` by default, in which case the server never asks the client for a certificate. With a
setting of `allow` the server will ask for a client certificate; if none is provided the session proceeds normally.
If a certificate is provided but the server is unable to verify it, the certificate is ignored and the session proceeds
normally, as if no certificate had been provided. With a setting of `try` the certificate is requested, and if none is
provided, the session proceeds normally. If a certificate is provided and it cannot be verified, the session is
immediately terminated. With a setting of `demand` the certificate is requested and a valid certificate must be
provided, otherwise the session is immediately terminated.

### `LDAP_TLS_REQCERT`

This environment variable specifies what checks to perform on server certificates. Only effective with LDAP
replication over TLS (e.g. `LDAP_REPLICATION_HOSTS=ldaps://ldap1/ ldaps://ldap2/`). This option is set to `never`
by default, to disable the verification that the CN of the received server certificate match its host name - otherwise
replication over TLS with the provided default server certificate will not work.

### `LDAP_REPLICATION_HOSTS`

This environment variable specifies a space separated list of LDAP URLs to activate
[N-Way Multi-Master replication](http://www.openldap.org/doc/admin24/replication.html#N-Way%20Multi-Master%20replication).
The list must contain the own container host name. Other host names of other servers must be resolvable by the container.
After startup you have to invoke
```
docker exec <ldap-container-name> prepare-replication
```
on each container, before actual activating the replication by
```
docker exec <ldap-container-name> enable-replication
```
on each container.

### `LDAP_REPLICATION_DB_SYNCPROV`

This environment variable specifies parameters used for
[N-Way Multi-Master replication](http://www.openldap.org/doc/admin24/replication.html#N-Way%20Multi-Master%20replication)
activated by `LDAP_REPLICATION_HOSTS`. Default value is
```
binddn="cn=admin,$LDAP_BASE_DN" \
bindmethod=simple \
credentials=$LDAP_ROOTPASS \
searchbase="$LDAP_BASE_DN" \
type=refreshOnly \
interval=00:00:00:10 \
retry="5 5 300 +" \
timeout=1
```

### `ARCHIVE_DEVICE_NAME`

This is the name of archive device. Default value is `dcm4chee-arc`.

### `AE_TITLE`

This is the name of the primary Application Entity title of archive device. Default value is `DCM4CHEE`.

### `ARCHIVE_HOST`

This is the hostname of the archive device. You have to specify the hostname of the docker host on which the Archive
container is deployed, if the LDAP configuration is used by other applications to determine the hostname and DICOM and/or
HL7 port to initiate TCP connections to the Archive. Default value is `127.0.0.1`.

### `DICOM_PORT`

This is the port number on which the Archive is listening for DICOM connections. Default value is `11112`.

### `HL7_PORT`

This is the port number on which the HL7 receiver of the Archive is listening. Default value is `2575`.

### `STORAGE_DIR`

This is the path to the directory - inside of the Archive container - where the Archive stores received DICOM objects.
Default value is `/opt/wildfly/standalone/data/fs1`. 

### `SYSLOG_DEVICE_NAME`

This is the device name of the audit record repository. The archive device emits audit messages to this device if 
audit logging is enabled. Default value is `logstash`. 

### `SYSLOG_HOST`

This is the hostname of the audit record repository. You have to specify either the hostname of the docker host on which
the Logstash container is deployed or - if the Archive container and the Logstash container are attached to the same
network - the container name of the Logstash container. With default value `127.0.0.1`, audit logging is effectively
disabled.

### `SYSLOG_PORT`

This is the port number on which the audit record repository is listening. Default value is `8514`. 

### `SYSLOG_PROTOCOL`

This is the protocol used to emit audit messages to the audit record repository. Enumerated values: `UDP` or `TCP`.
Default value is `UDP`. 

### `KEYCLOAK_DEVICE_NAME`

This is the device name of the Keycloak Authentication Server. It specifies the emission of audit messages for
authentication events. Default value is `keycloak`. 

### `KEYCLOAK_HOST`

This is the device name of the Keycloak Authentication Server. It specifies the emission of audit messages for
authentication events. Default value is `127.0.0.1`. 

### `SCHEDULED_STATION_DEVICE_NAME`

This is the name of the device referenced in default scheduled station configured in the archive device which is used  as 
a fallback option for populating the Scheduled Station AE title in the Modality Worklist attributes when HL7 order messages 
are received by the archive. Default value is `scheduledstation`. 

### `SCHEDULED_STATION_AE_TITLE`

This is the Application Entity title of the device referenced in default scheduled station configured in the archive device which is used  as 
a fallback option for populating the Scheduled Station AE title in the Modality Worklist attributes when HL7 order messages 
are received by the archive. Default value is `SCHEDULEDSTATION`. 

### `ELASTICSEARCH_URL`

Base URL of Elasticsearch used by [dcm4che-pro](http://web.j4care.com/dcm4chepro) version of the UI. Default value
is `http://localhost:9200`. 

### `SKIP_INIT_CONFIG`

Skip the default initial configuration (required by archive device) at first LDAP startup. Default value is set to `false`.

### `EXT_INIT_CONFIG`

Space separated LDIF files to be imported additionally at first LDAP startup

replacing | by
-- | --
`dc=dcm4che,dc=org` | `${LDAP_BASE_DN}`
`dcm4chee-arc` | `${ARCHIVE_DEVICE_NAME}`
`DCM4CHEE` | `${AE_TITLE}`
`archive-host` | `${ARCHIVE_HOST}`
`scheduledstation` | `${SCHEDULED_STATION_DEVICE_NAME}`
`SCHEDULEDSTATION` | `${SCHEDULED_STATION_AE_TITLE}`
`keycloak` | `${KEYCLOAK_DEVICE_NAME}`
`keycloak-host` | `${KEYCLOAK_HOST}`
`11112` | `${DICOM_PORT}`
`2575` | `${HL7_PORT}`
`logstash` | `${SYSLOG_DEVICE_NAME}`
`syslog-host` | `${SYSLOG_HOST}`
`514` | `${SYSLOG_PORT}`
`SYSLOG_UDP` | `SYSLOG_${SYSLOG_PROTOCOL}`
`${jboss.server.data.url}/fs1` | `file://${STORAGE_DIR}`
`http://localhost:9200` | `${ELASTICSEARCH_URL}`

Only effective if `SKIP_INIT_CONFIG=false`. Not set by default.

### `IMPORT_LDIF`

Space separated LDIF files to be imported verbatim at first LDAP startup. May be used together with
`SKIP_INIT_CONFIG=true` to initialize LDAP from customized or backed-up LDIF file(s) instead of using
the default initial configuration.
