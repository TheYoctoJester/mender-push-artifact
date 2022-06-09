#!/bin/sh -l

JWT=$(curl -s -X POST -u ${INPUT_MENDER_USER}:${INPUT_MENDER_PASSWORD} ${INPUT_MENDER_URI}/api/management/v1/useradm/auth/login)

curl -s -X POST ${INPUT_MENDER_URI}/api/management/v1/deployments/artifacts \
-H 'Content-Type: multipart/form-data' \
-H 'Accept: application/json' \
-H "Authorization: Bearer ${JWT}" \
-F artifact=@${GITHUB_WORKSPACE}/${INPUT_MENDER_ARTIFACT}