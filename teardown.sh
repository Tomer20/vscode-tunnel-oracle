#!/usr/bin/env bash

set -e

COMPARTMENT_NAME="${OCI_COMPARTMENT_NAME:-vscode-tunnel-compartment}"
BUCKET_NAME="${OCI_BUCKET_NAME:-vscode-tunnel-bucket}"
NAMESPACE=$(oci os ns get | jq -r '.data')
TENANCY_OCID="$OCI_TENANCY_OCID"

echo "🧨 Starting teardown..."

# Get Compartment ID
COMPARTMENT_ID=$(oci iam compartment list --all \
  --name "$COMPARTMENT_NAME" \
  --compartment-id "$TENANCY_OCID" \
  | jq -r '.data[0].id')

# Delete all objects and versions if the bucket exists
if oci os bucket get --name "$BUCKET_NAME" --namespace-name "$NAMESPACE" > /dev/null 2>&1; then
  echo "🗑 Deleting objects (including versions) from bucket: $BUCKET_NAME"

  OBJECTS=$(oci os object list --bucket-name "$BUCKET_NAME" --namespace-name "$NAMESPACE" --all \
    | jq -r '.data[].name')

  for OBJECT in $OBJECTS; do
    echo " - Deleting object and all versions: $OBJECT"
    # Get all versions of the object
    VERSIONS=$(oci os object list --bucket-name "$BUCKET_NAME" --namespace-name "$NAMESPACE" --all --include-versions true \
      | jq -r --arg name "$OBJECT" '.data[] | select(.name == $name) | .version-id')

    for VERSION_ID in $VERSIONS; do
      oci os object delete \
        --bucket-name "$BUCKET_NAME" \
        --namespace-name "$NAMESPACE" \
        --name "$OBJECT" \
        --version-id "$VERSION_ID" \
        --force
    done
  done

  echo "📦 Deleting bucket: $BUCKET_NAME"
  oci os bucket delete --name "$BUCKET_NAME" --namespace-name "$NAMESPACE" --force
else
  echo "Bucket $BUCKET_NAME does not exist, skipping."
fi

# Delete compartment if it exists
if [[ -n "$COMPARTMENT_ID" && "$COMPARTMENT_ID" != "null" ]]; then
  echo "🏗 Deleting compartment: $COMPARTMENT_NAME"
  oci iam compartment delete --compartment-id "$COMPARTMENT_ID" --force
else
  echo "Compartment $COMPARTMENT_NAME does not exist, skipping."
fi

echo "✅ Teardown complete"