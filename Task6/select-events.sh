#!/bin/bash

jq 'select(.objectRef.resource=="secrets" and (.verb=="list" or .verb=="get") and .responseStatus.status=="Failure")' audit.log > audit-extract.json
jq 'select(.objectRef.subresource=="exec")' audit.log >> audit-extract.json
jq 'select(.objectRef.resource=="pods" and (.requestObject.spec.containers | length)>0 and .requestObject.spec.containers[].securityContext.privileged==true) ' audit.log >> audit-extract.json
jq 'select(.objectRef.resource=="rolebindings" and .verb=="create")' audit.log >> audit-extract.json
