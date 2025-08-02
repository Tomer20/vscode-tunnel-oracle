#!/usr/bin/env bash

set -euo pipefail

COMPARTMENT_NAME="${OCI_COMPARTMENT_NAME:-vscode-tunnel-compartment}"
BUCKET_NAME="${OCI_BUCKET_NAME:-vscode-tunnel-bucket}"
TENANCY_OCID="${OCI_TENANCY_OCID:?OCI_TENANCY_OCID must be set}"
NAMESPACE=$(oci os ns get | jq -r '.data')

echo "🧨 Starting teardown..."

# Get Compartment ID
COMPARTMENT_ID=$(oci iam compartment list --all \
  --name "$COMPARTMENT_NAME" \
  --compartment-id "$TENANCY_OCID" \
  | jq -r '.data[0].id // empty')

if [[ -z "$COMPARTMENT_ID" || "$COMPARTMENT_ID" == "null" ]]; then
  echo "❌ Compartment '$COMPARTMENT_NAME' not found. Skipping bucket teardown."
  COMPARTMENT_ID=""
else
  # Check if bucket exists
  if ! oci os bucket get --bucket-name "$BUCKET_NAME" --namespace-name "$NAMESPACE" > /dev/null 2>&1; then
    echo "❌ Bucket '$BUCKET_NAME' not found. Skipping object and bucket deletion."
  else
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

    while read -r OBJECT_ENTRY; do
      OBJECT_NAME=$(echo "$OBJECT_ENTRY" | jq -r '.name // empty')
      VERSION_ID=$(echo "$OBJECT_ENTRY" | jq -r '."version-id" // empty')

      if [[ -n "$VERSION_ID" ]]; then
        echo " - Deleting versioned object: ${OBJECT_NAME:-<no-name>} (version: $VERSION_ID)"
        oci os object delete \
          --bucket-name "$BUCKET_NAME" \
          --namespace-name "$NAMESPACE" \
          --name "$OBJECT_NAME" \
          --version-id "$VERSION_ID" \
          --force
      elif [[ -n "$OBJECT_NAME" ]]; then
        echo " - Deleting object without version: $OBJECT_NAME"
        oci os object delete \
          --bucket-name "$BUCKET_NAME" \
          --namespace-name "$NAMESPACE" \
          --name "$OBJECT_NAME" \
          --force
      else
        echo "❓ Skipping unknown object entry: $OBJECT_ENTRY"
      fi
    done < <(echo "$OBJECT_LIST_JSON" | jq -c '.data[]')

    echo "🪣 Deleting bucket: $BUCKET_NAME"
    oci os bucket delete \
      --bucket-name "$BUCKET_NAME" \
      --namespace-name "$NAMESPACE" \
      --force
  fi

  echo "🏗 Deleting compartment: $COMPARTMENT_NAME"
  oci iam compartment delete --compartment-id "$COMPARTMENT_ID" --force
fi

echo "✅ Teardown complete"
