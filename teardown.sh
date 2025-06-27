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

  # Get list of all objects with versions
  OBJECTS=$(oci os object list --bucket-name "$BUCKET_NAME" --namespace-name "$NAMESPACE" --all --include-versions true)

  echo "$OBJECTS" | jq -c '.data[]' | while read -r OBJECT_ENTRY; do
    OBJECT_NAME=$(echo "$OBJECT_ENTRY" | jq -r '.name')
    VERSION_ID=$(echo "$OBJECT_ENTRY" | jq -r '.["version-id"] // empty')

    if [[ -n "$VERSION_ID" ]]; then
      echo " - Deleting versioned object: $OBJECT_NAME (version: $VERSION_ID)"
      oci os object delete \
        --bucket-name "$BUCKET_NAME" \
        --namespace-name "$NAMESPACE" \
        --name "$OBJECT_NAME" \
        --version-id "$VERSION_ID" \
        --force
    else
      echo " - Deleting unversioned object: $OBJECT_NAME"
      oci os object delete \
        --bucket-name "$BUCKET_NAME" \
        --namespace-name "$NAMESPACE" \
        --name "$OBJECT_NAME" \
        --force
    fi
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