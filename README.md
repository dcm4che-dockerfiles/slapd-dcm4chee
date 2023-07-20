This docker image provides LDAP Server initalized for the DICOM Archive
[dcm4chee-arc-light](https://github.com/dcm4che/dcm4chee-arc-light/wiki).
It extends the [dcm4che slapd image](https://hub.docker.com/r/dcm4che/slapd/).

# How to use this image

## start a slapd instance

```
$ docker run --name slapd \
             -p 389:389 \
             -v /var/local/dcm4chee-arc/ldap:/var/lib/openldap/openldap-data \
             -v /var/local/dcm4chee-arc/slapd.d:/etc/openldap/slapd.d \
             -d dcm4che/slapd-dcm4chee:2.6.5-31.0
```

## Environment Variables

Below explained environment variables can be set as per one's application to override the default values if need be.
An example of how one can set an env variable in `docker run` command is shown below :

    -e LDAP_ROOTPASS=mypass

### `LDAP_USER_ID`

`uid` of the ldap user running `slapd` inside the container (optional, default is `1021`).

### `LDAP_GROUP_ID`

`gid` of the ldap user running `slapd` inside the container (optional, default is `1021`).

### `LDAP_DEBUG`

Debug-level specified as bit string, with each bit corresponding to a different kind of debugging information:

Component | bit string
-- | --
Any | (-1, 0xffffffff)
Trace | (1, 0x1)
Packets | (2, 0x2)
Args | (4, 0x4)
Conns | (8, 0x8)
BER | (16, 0x10)
Filter | (32, 0x20)
Config | (64, 0x40)
ACL | (128, 0x80)
Stats | (256, 0x100)
Stats2 | (512, 0x200)
Shell | (1024, 0x400)
Parse | (2048, 0x800)
Sync | (16384, 0x4000)
None | (32768, 0x8000)

Set to `32768` by default.

### `LDAP_INIT_SCHEMA`

Space separated list of schema definition LDIF files applied at first LDAP startup.
Relative file paths are resolved against `/etc/openldap/schema/`.
`dicom.ldif dcm4che.ldif dcm4chee-archive.ldif dcm4chee-archive-ui.ldif` by default.

### `LDAP_UPDATE_SCHEMA`

Space separated list of schema definition update LDIF files applied by script `update-schema`.
Relative file paths are resolved against `/etc/openldap/schema/`.
`dicom-modify.ldif dcm4che-modify.ldif dcm4chee-archive-modify.ldif dcm4chee-archive-ui-modify.ldif` by default.

### `LDAP_BASE_DN`

Base domain name for LDAP (optional, default is `dc=dcm4che,dc=org`).

### `LDAP_ORGANISATION`

Organisation name in LDAP root node (optional, default is `dcm4che.org`).

### `LDAP_ROOTPASS`

Root DN password (bind DN: `cn=admin,${LDAP_BASE_DN}`) (optional, default is `secret`).

### `LDAP_ROOTPASS_FILE`

Root DN password (bind DN: `cn=admin,${LDAP_BASE_DN}`) via file input (alternative to `LDAP_ROOTPASS`).

### `LDAP_CONFIGPASS`

Config DIT password (bind DN `cn=admin,cn=config`) (optional, default is `secret`).

### `LDAP_CONFIGPASS_FILE`

Config DIT password (bind DN `cn=admin,cn=config`) via file input (alternative to `LDAP_CONFIGPASS`).

### `LDAP_URLS`

Space separated list of LDAP URLs to serve.
Set to `"ldap:///"` by default (LDAP over TCP on all interfaces on default LDAP port).
The default `ldap://` port is `389` and the default `ldaps://` port is `636`.
Required if configuring [N-Way Multi-Provider Replication](https://www.openldap.org/doc/admin26/replication.html#N-Way%20Multi-Provider%20Replication)
by [LDAP_REPLICATION_HOSTS](#ldap_replication_hosts).

### `LDAP_EXTRA_HOST`

Add mapping of specified hostname to `$(hostname -i)` or particular container IP with `LDAP_EXTRA_HOST_IP_PREFIX` to `/etc/hosts`.

#### `LDAP_EXTRA_HOST_IP_PREFIX`

Prefix used to select particular container IP to map to `LDAP_EXTRA_HOST` (optional, map `$(hostname -i)` by default).

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
[N-Way Multi-Provider Replication](https://www.openldap.org/doc/admin26/replication.html#N-Way%20Multi-Provider%20Replication).
The list must contain the own container host name. Other host names of other servers must be resolvable by the container.
The order of LDAP URLs must be the same for each server.

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
[N-Way Multi-Provider Replication](https://www.openldap.org/doc/admin26/replication.html#N-Way%20Multi-Provider%20Replication)
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

### `AUTH_USER`

Created user with password `changeit` with assigned Realm Role specified by [AUTH_USER_ROLE](#AUTH_USER_ROLE),
to access non-adminstrative functions of the UI and RESTful services of the Archive (optional, default is `user`).

### `AUTH_USER_ROLE`

Created user role required to access non-adminstrative functions of the UI and RESTful services of the Archive
(optional, default is `user`).

### `ADMIN_USER`

Created user with password `changeit` with assigned Realm Role specified by [AUTH_USER_ROLE](#AUTH_USER_ROLE) and
[ADMIN_USER_ROLE](#ADMIN_USER_ROLE), to access (including adminstrative) functions of the UI and RESTful services
of the Archive (optional, default is `admin`).

### `ADMIN_USER_ROLE`

Created user role required to access adminstrative functions of the UI (optional, default is `admin`).

### `SUPER_USER`

Created user with password `changeit` with assigned Realm Roles specified by [AUTH_USER_ROLE](#AUTH_USER_ROLE) and
[SUPER_USER_ROLE](#SUPER_USER_ROLE), to access the UI without verification of user permissions (optional, default is `root`).

### `SUPER_USER_ROLE`

User role to identify super users, which have unrestricted access to all UI functions of the Archive, bypassing the
verification of user permissions (optional, default is `root`).

### `ARCHIVE_DEVICE_NAME`

Name of the archive device. Default value is `dcm4chee-arc`.

### `ARCHIVE_WEBAPP_NAME`

Name of the Web Application associated with the archive device. Default value is `dcm4chee-arc`.

### `AE_TITLE`

Title of the primary Application Entity configured to hide instances rejected for Quality Reasons.
Value shall be different from any other configured `AE_TITLE_XY`.
Default value is `DCM4CHEE`.

### `AE_TITLE_IOCM_REGULAR_USE`

Title of the Application Entity configured to show instances rejected for Quality Reasons.
Value shall be different from [AE_TITLE](#AE_TITLE) and any other configured `AE_TITLE_XY`.
Default value is `IOCM_REGULAR_USE`.

### `AE_TITLE_IOCM_QUALITY`

Title of the Application Entity configured to only show instances rejected for Quality Reasons.
Value shall be different from [AE_TITLE](#AE_TITLE) and any other configured `AE_TITLE_XY`.
Default value is `IOCM_QUALITY`.

### `AE_TITLE_IOCM_PAT_SAFETY`

Title of the Application Entity configured to only show instances rejected for Patient Safety Reasons.
Value shall be different from [AE_TITLE](#AE_TITLE) and any other configured `AE_TITLE_XY`.
Default value is `IOCM_PAT_SAFETY`.

### `AE_TITLE_IOCM_WRONG_MWL`

Title of the Application Entity configured to only show instances rejected for Incorrect Modality Worklist Entry.
Value shall be different from [AE_TITLE](#AE_TITLE) and any other configured `AE_TITLE_XY`.
Default value is `IOCM_WRONG_MWL`.

### `AE_TITLE_IOCM_EXPIRED`

Title of the Application Entity configured to only show instances rejected for Data Retention Expired.
Value shall be different from [AE_TITLE](#AE_TITLE) and any other configured `AE_TITLE_XY`.
Default value is `IOCM_EXPIRED`.

### `AE_TITLE_AS_RECEIVED`

Title of the Application Entity configured to retrieve instances as received.
Value shall be different from [AE_TITLE](#AE_TITLE) and any other configured `AE_TITLE_XY`
Default value is `AS_RECEIVED`.

### `AE_TITLE_WORKLIST`

Title of the Application Entity providing Modality Worklist and Unified Worklist Services.
Value shall be different from [AE_TITLE](#AE_TITLE) and any other configured `AE_TITLE_XY`.
Default value is `WORKLIST`.
To provide Modality Worklist and Unified Worklist Services also by the primary Application Entity configured by
[AE_TITLE](#AE_TITLE), you may invoke provided script `add-mwl-ups` in the running container:
```console
$ docker exec {ldap-container-id-or-name} add-mwl-ups
ldapmodify -f add-mwl-ups.ldif
modifying entry "dcmWebAppName=DCM4CHEE,dicomDeviceName=dcm4chee-arc,cn=Devices,cn=DICOM Configuration,dc=dcm4che,dc=org"
adding new entry "cn=Unified Procedure Step - Pull SOP Class SCP,dicomAETitle=DCM4CHEE,dicomDeviceName=dcm4chee-arc,cn=Devices,cn=DICOM Configuration,dc=dcm4che,dc=org"
adding new entry "cn=Unified Procedure Step - Push SOP Class SCP,dicomAETitle=DCM4CHEE,dicomDeviceName=dcm4chee-arc,cn=Devices,cn=DICOM Configuration,dc=dcm4che,dc=org"
adding new entry "cn=Unified Procedure Step - Event SOP Class SCP,dicomAETitle=DCM4CHEE,dicomDeviceName=dcm4chee-arc,cn=Devices,cn=DICOM Configuration,dc=dcm4che,dc=org"
adding new entry "cn=Unified Procedure Step - Query SOP Class SCP,dicomAETitle=DCM4CHEE,dicomDeviceName=dcm4chee-arc,cn=Devices,cn=DICOM Configuration,dc=dcm4che,dc=org"
adding new entry "cn=Unified Procedure Step - Watch SOP Class SCP,dicomAETitle=DCM4CHEE,dicomDeviceName=dcm4chee-arc,cn=Devices,cn=DICOM Configuration,dc=dcm4che,dc=org"
adding new entry "cn=Modality Worklist Information Model - FIND SCP,dicomAETitle=DCM4CHEE,dicomDeviceName=dcm4chee-arc,cn=Devices,cn=DICOM Configuration,dc=dcm4che,dc=org"
```

### `ARCHIVE_HOST`

Hostname of the archive device. You have to specify the hostname of the docker host on which the Archive
container is deployed, if the LDAP configuration is used by other applications to determine the hostname and DICOM and/or
HL7 port to initiate TCP connections to the Archive. Default value is `127.0.0.1`.

### `DICOM_PORT`

Port number on which the Archive is listening for DICOM connections. Default value is `11112`.

### `DICOM_TLS_PORT`

Port number on which the Archive is listening for DICOM TLS connections. Default value is `2762`.

### `HL7_PORT`

Port number on which the HL7 receiver of the Archive is listening. Default value is `2575`.

### `HL7_TLS_PORT`

Port number on which the HL7 TLS receiver of the Archive is listening. Default value is `12575`.

### `STORAGE_DIR`

Path to the directory - inside of the Archive container - where the Archive stores received DICOM objects.
Default value is `/opt/wildfly/standalone/data/fs1`. 

### `SYSLOG_DEVICE_NAME`

Device name of the audit record repository. The archive device emits audit messages to this device if 
audit logging is enabled. Default value is `logstash`. 

### `SYSLOG_HOST`

Hostname of the audit record repository. You have to specify either the hostname of the docker host on which
the Logstash container is deployed or - if the Archive container and the Logstash container are attached to the same
network - the container name of the Logstash container. With default value `127.0.0.1`, audit logging is effectively
disabled.

### `SYSLOG_PORT`

Port number on which the audit record repository is listening. Default value is `514`. 

### `SYSLOG_PROTOCOL`

Protocol used to emit audit messages to the audit record repository. Enumerated values: `UDP` or `TCP`.
Default value is `UDP`. 

### `SYSLOG_TLS_PORT`

Pre-configured syslog-tls port of the audit record repository. Default value is `6514`. 

### `KEYCLOAK_DEVICE_NAME`

Device name of the Keycloak Authentication Server. It specifies the emission of audit messages for
authentication events. Default value is `keycloak`. 

### `KEYCLOAK_HOST`

Device name of the Keycloak Authentication Server. It specifies the emission of audit messages for
authentication events. Default value is `127.0.0.1`. 

### `SCHEDULED_STATION_DEVICE_NAME`

Name of the device referenced in default scheduled station configured in the archive device which is used  as 
a fallback option for populating the Scheduled Station AE title in the Modality Worklist attributes when HL7 order messages 
are received by the archive. Default value is `scheduledstation`. 

### `SCHEDULED_STATION_AE_TITLE`

Application Entity title of the device referenced in default scheduled station configured in the archive device which is used  as 
a fallback option for populating the Scheduled Station AE title in the Modality Worklist attributes when HL7 order messages 
are received by the archive. Default value is `SCHEDULEDSTATION`. 

### `STORESCP_DEVICE_NAME`

Name of the device of external C-STORE SCP with limited Transfer Capabilities in default configuration. Default value is `storescp`. 

### `STORESCP_AE_TITLE`

Application Entity title of external C-STORE SCP with limited Transfer Capabilities in default configuration. Default value is `STORESCP`. 

### `STORESCP_HOST`

Device name of external C-STORE SCP with limited Transfer Capabilities in default configuration. Default value is `storescp`.

### `STORESCP_PORT`

Port number of external C-STORE SCP with limited Transfer Capabilities in default configuration. Default value is `11117`.

### `IID_PATIENT_URL`

URL to launch external Image Display for a Patient. `{{patientID}}` will be replaced by the Patient ID formatted as
HL7 CX data type. `&` has to be escaped by `\&`.
E.g.: `http(s)://<viewer-host>:<viewer-port>/IHEInvokeImageDisplay?requestType=PATIENT\&patientID={{patientID}}`.

### `IID_STUDY_URL`

URL to launch external Image Display for a Study. `{{studyUID}}` will be replaced by the Study Instance UID.
`&` has to be escaped by `\&`.
E.g.: `http(s)://<viewer-host>:<viewer-port>/IHEInvokeImageDisplay?requestType=STUDY\&studyUID={{studyUID}}`.

### `IID_URL_TARGET`

Window/target name applied to Invoke Image Display URL to launch external Image Display for a Patient or Study.
Use `_self` to suppress opening a new window.

### `LDAP_INIT_CMDS`

Space separated list of scripts invoked on each LDAP startup. `/etc/openldap/configure.sh` by default.

### `LDAP_CONFIG_SED`

Specifies the command to apply environment variables on importing LDIF files specified by `LDAP_INIT_CONFIG`
at first LDAP startup or by script `init-config`, as on LDIF files used to modify the LDAP data
on upgrading the Archive version by script `updata-data <archive-version>`; `sed-config` by default.

### `SKIP_INIT_CONFIG`

Skip the default initial configuration (required by archive device) at first LDAP startup. Default value is `false`.

### `LDAP_INIT_CONFIG`
            
Space separated list of LDIF files to be imported at first LDAP startup or by script `init-config` initializing configuration.
Relative file paths are resolved against `/etc/openldap/data/`.
`init-config.ldif dcm4chee-arc.ldif keycloak.ldif logstash.ldif storescp.ldif stowrsd.ldif scheduledstation.ldif add-vendor-data.ldif default-ui-config.ldif` by default.

Not effective if `SKIP_INIT_CONFIG=true`.

### `LDAP_INIT_USERS`

Space separated list of LDIF files to be imported at first LDAP startup initializing Keycloak User Federation.
Relative file paths are resolved against `/etc/openldap/data/`.
`default-users.ldif` by default.

Not effective if `SKIP_INIT_CONFIG=true`.

### `IMPORT_LDIF`

Space separated LDIF files to be imported verbatim at first LDAP startup. May be used together with
`SKIP_INIT_CONFIG=true` to initialize LDAP from customized or backed-up LDIF file(s) instead of using
the default initial configuration.

### `EXT_VENDOR_DATA_PATH`

Space separated paths to directories or ZIP files merged with default vendor data, effective on first LDAP startup,
invoke of `update-data <version>` or `replace-vendor-data`.
