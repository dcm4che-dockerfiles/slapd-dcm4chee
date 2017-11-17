#!/usr/bin/awk -f
$1 == "dn:" {
print
print "changetype: modify"
print "delete: dicomTransferSyntax"
print "dicomTransferSyntax: 1.2.840.10008.1.2.4.90"
print "dicomTransferSyntax: 1.2.840.10008.1.2.4.91"
print "-"
print ""
}
