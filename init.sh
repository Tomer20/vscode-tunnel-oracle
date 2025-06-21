#!/usr/bin/env bash

set -e


COMPARTMENT_NAME="${OCI_COMPARTMENT_NAME:-vscode-tunnel-compartment}"
BUCKET_NAME="${OCI_BUCKET_NAME:-vscode-tunnel-bucket}"
NAMESPACE=$(oci os ns get | jq -r '.data')
TENANCY_OCID="$OCI_TENANCY_OCID"

# Check if compartment exists
COMPARTMENT_ID=$(oci iam compartment list --all \
  --name "$COMPARTMENT_NAME" \
  --compartment-id "$TENANCY_OCID" \
  | jq -r '.data[0].id')

if [[ -z "$COMPARTMENT_ID" || "$COMPARTMENT_ID" == "null" ]]; then
  echo "Creating compartment: $COMPARTMENT_NAME"
  COMPARTMENT_ID=$(oci iam compartment create \
    --name "$COMPARTMENT_NAME" \
    --compartment-id "$TENANCY_OCID" \
    --description "Compartment for VS Code Tunnel state" \
    --query 'data.id' --raw-output)
else
  echo "Compartment already exists: $COMPARTMENT_NAME"
fi

# Check if bucket exists
if oci os bucket get --name "$BUCKET_NAME" --namespace-name "$NAMESPACE" --compartment-id "$COMPARTMENT_ID" > /dev/null 2>&1; then
  echo "Bucket already exists: $BUCKET_NAME"
else
  echo "Creating bucket: $BUCKET_NAME"
  oci os bucket create \
    --name "$BUCKET_NAME" \
    --compartment-id "$COMPARTMENT_ID" \
    --namespace "$NAMESPACE" \
    --storage-tier Standard \
    --public-access-type NoPublicAccess \
    --versioning "Enabled" \
    --query 'data.name' --raw-output
fi

echo "✅ Init complete"