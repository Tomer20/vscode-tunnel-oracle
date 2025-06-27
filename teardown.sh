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

echo "🧹 Deleting all objects and versions in bucket: $BUCKET_NAME"
OBJECT_LIST_JSON=$(oci os object list \
  --bucket-name "$BUCKET_NAME" \
  --namespace-name "$NAMESPACE" \
  --all \
  --include-versions true 2>&1)

if [[ $? -ne 0 ]]; then
  echo "❌ Failed to list objects with versions:"
  echo "$OBJECT_LIST_JSON"
  exit 2
fi

echo "$OBJECT_LIST_JSON" | jq -c '.data[]' | while read -r OBJECT_ENTRY; do
  OBJECT_NAME=$(echo "$OBJECT_ENTRY" | jq -r '.name')
  VERSION_ID=$(echo "$OBJECT_ENTRY" | jq -r '.["version-id"] // empty')

  if [[ -n "$OBJECT_NAME" ]]; then
    if [[ -n "$VERSION_ID" ]]; then
      echo " - Deleting versioned object: $OBJECT_NAME (version: $VERSION_ID)"
      oci os object delete \
        --bucket-name "$BUCKET_NAME" \
        --namespace-name "$NAMESPACE" \
        --name "$OBJECT_NAME" \
        --version-id "$VERSION_ID" \
        --force
    else
      echo " - Deleting object without version: $OBJECT_NAME"
      oci os object delete \
        --bucket-name "$BUCKET_NAME" \
        --namespace-name "$NAMESPACE" \
        --name "$OBJECT_NAME" \
        --force
    fi
  fi
done

# Delete compartment if it exists
if [[ -n "$COMPARTMENT_ID" && "$COMPARTMENT_ID" != "null" ]]; then
  echo "🏗 Deleting compartment: $COMPARTMENT_NAME"
  oci iam compartment delete --compartment-id "$COMPARTMENT_ID" --force
else
  echo "Compartment $COMPARTMENT_NAME does not exist, skipping."
fi

echo "✅ Teardown complete"