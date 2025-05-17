#!/bin/bash

# Default values
TABLE="source_table"
REGION="ap-southeast-1"
MAX_ITEMS=1000
LOCAL_URL="http://localhost:4569"
LOCAL_TABLE="local_table"
EXPORT_ONLY=false
IMPORT_ONLY=false
CONTEXT_ID=$(date +%Y%m%d%H%M%S)
OPERATION="query"

# Function to display help
show_help() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --table, -t        Source DynamoDB table name (default: source_table)"
  echo "  --region, -r       AWS region (default: ap-southeast-1)"
  echo "  --max-items, -m    Maximum items per batch (default: 1000)"
  echo "  --local-url, -l    Local DynamoDB URL (default: http://localhost:4569)"
  echo "  --local-table, -lt Local DynamoDB table name (default: local_table)"
  echo "  --operation, -o    DynamoDB operation: query or scan (default: query)"
  echo "  --pk               Partition key value (required for query)"
  echo "  --sk               Sort key value (optional for query)"
  echo "  --filter, -f       Filter expression (optional)"
  echo "  --attributes, -a   Expression attribute values as JSON (optional)"
  echo "  --index, -i        Secondary index to use (optional)"
  echo "  --projection, -p   Projection expression (optional)"
  echo "  --context-id, -c   Unique context ID (default: timestamp)"
  echo "  --export-only, -e  Only export data, don't import"
  echo "  --import-only      Only import existing files, don't export"
  echo "  --help, -h         Show this help message"
  echo ""
  echo "Examples:"
  echo "  # Simple query by partition key"
  echo "  $0 --table users --pk user123"
  echo ""
  echo "  # Query with additional filter"
  echo "  $0 --table users --pk user123 --filter \"age > :age\" --attributes '{\":age\":{\"N\":\"18\"}}'"
  echo ""
  echo "  # Scan with filter"
  echo "  $0 --table users --operation scan --filter \"status = :status\" --attributes '{\":status\":{\"S\":\"active\"}}'"
  echo ""
  echo "  # Using secondary index"
  echo "  $0 --table users --operation query --index email-index --pk \"user@example.com\" --projection \"id, name, email\""
}

# Parse command line arguments
parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --table|-t)
        TABLE="$2"
        shift 2
        ;;
      --region|-r)
        REGION="$2"
        shift 2
        ;;
      --max-items|-m)
        MAX_ITEMS="$2"
        shift 2
        ;;
      --local-url|-l)
        LOCAL_URL="$2"
        shift 2
        ;;
      --local-table|-lt)
        LOCAL_TABLE="$2"
        shift 2
        ;;
      --pk)
        PK="$2"
        shift 2
        ;;
      --sk)
        SK="$2"
        shift 2
        ;;
      --context-id|-c)
        CONTEXT_ID="$2"
        shift 2
        ;;
      --operation|-o)
        OPERATION="$2"
        shift 2
        ;;
      --filter|-f)
        FILTER="$2"
        shift 2
        ;;
      --attributes|-a)
        ATTR_VALUES="$2"
        shift 2
        ;;
      --index|-i)
        INDEX="$2"
        shift 2
        ;;
      --projection|-p)
        PROJECTION="$2"
        shift 2
        ;;
      --export-only|-e)
        EXPORT_ONLY=true
        shift
        ;;
      --import-only)
        IMPORT_ONLY=true
        shift
        ;;
      --help|-h)
        show_help
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
  done
}

# Validate input parameters
validate_parameters() {
  if [[ "$IMPORT_ONLY" == "false" && "$OPERATION" == "query" && -z "$PK" ]]; then
    echo "Error: Partition key (--pk) is required for query operation"
    exit 1
  fi
}

# Build the AWS CLI command dynamically
build_aws_command() {
  local cmd="aws dynamodb $OPERATION --table-name \"$TABLE\" --region \"$REGION\" --max-items \"$MAX_ITEMS\""

  # Add operation-specific parameters
  if [[ "$OPERATION" == "query" ]]; then
    # Define key names based on whether an index is used
    local pk_name="pk"
    local sk_name="sk"
    if [[ -n "$INDEX" ]]; then
      pk_name="${INDEX}pk"
      sk_name="${INDEX}sk"
    fi

    # Build key condition expression
    local key_condition="$pk_name=:pk"
    if [[ -n "$SK" ]]; then
      key_condition+=" and $sk_name=:sk"
    fi

    cmd+=" --key-condition-expression \"$key_condition\""

    # Build attribute values for key condition
    local attr_values="{\":pk\":{\"S\":\"$PK\"}"
    if [[ -n "$SK" ]]; then
      attr_values+=",\":sk\":{\"S\":\"$SK\"}"
    fi

    # If additional attributes are provided, merge them
    if [[ -n "$ATTR_VALUES" ]]; then
      # Remove the closing brace from attr_values
      attr_values="${attr_values%\}}"
      # Remove the opening brace from ATTR_VALUES
      local additional_attrs="${ATTR_VALUES#\{}"
      # Combine them
      attr_values+=",$additional_attrs"
    else
      attr_values+="}"
    fi

    cmd+=" --expression-attribute-values '$attr_values'"
  elif [[ -n "$ATTR_VALUES" ]]; then
    # For scan operations with attribute values
    cmd+=" --expression-attribute-values '$ATTR_VALUES'"
  fi

  # Add optional parameters
  if [[ -n "$FILTER" ]]; then
    cmd+=" --filter-expression \"$FILTER\""
  fi

  if [[ -n "$INDEX" ]]; then
    cmd+=" --index-name \"$INDEX\""
  fi

  if [[ -n "$PROJECTION" ]]; then
    cmd+=" --projection-expression \"$PROJECTION\""
  fi

  echo "$cmd"
}

# Export data from DynamoDB
export_data() {
  if [[ "$EXPORT_ONLY" == "true" || "$IMPORT_ONLY" == "false" ]]; then
    echo "Exporting data from $TABLE in $REGION using $OPERATION operation..."

    local next_token=""
    local index=0

    while true; do
      ((index+=1))
      local token_param=""
      if [[ -n "$next_token" ]]; then
        token_param="--starting-token $next_token"
      fi

      local aws_cmd=$(build_aws_command)
      aws_cmd+=" --output json $token_param"

      echo "Executing: $aws_cmd"
      local query_result=$(eval $aws_cmd)

      local output_file="${TABLE}-${CONTEXT_ID}-${index}.json"
      echo "$query_result" > "$output_file"
      echo "Exported batch $index to $output_file"

      next_token=$(echo "$query_result" | jq -r '.NextToken // empty')
      if [[ -z "$next_token" ]]; then
        break
      fi
    done

    echo "Export completed. Total batches: $index"
  fi
}

# Process items in batches for import
process_batch() {
  local file="$1"
  local items=$(cat "$file" | jq -c ".Items")

  if [[ "$items" == "null" ]]; then
    echo "No items found in $file, skipping"
    return
  fi

  local item_count=$(echo "$items" | jq '. | length')
  local batch_size=25
  local batch_count=$(( (item_count + batch_size - 1) / batch_size ))

  for ((batch=0; batch<batch_count; batch++)); do
    local start=$((batch * batch_size))
    local batch_items=$(echo "$items" | jq ".[$start:$((start + batch_size))]")

    local insert_file="inserts-${CONTEXT_ID}-${batch}.json"
    echo "$batch_items" | jq "{\"$LOCAL_TABLE\": [.[] | {\"PutRequest\": {\"Item\": .}}]}" > "$insert_file"

    aws dynamodb batch-write-item \
      --region "$REGION" \
      --request-items=file://"$insert_file" \
      --endpoint-url "$LOCAL_URL"

    rm "$insert_file"
    echo "Imported batch $((batch+1))/$batch_count from $file"
  done
}

# Import data to local DynamoDB
import_data() {
  if [[ "$IMPORT_ONLY" == "true" || "$EXPORT_ONLY" == "false" ]]; then
    echo "Importing data to $LOCAL_TABLE at $LOCAL_URL..."

    local files=$(ls -1 *${TABLE}-${CONTEXT_ID}*.json 2>/dev/null)
    if [[ -z "$files" ]]; then
      echo "No files found for import with context ID: $CONTEXT_ID"
      return
    fi

    for file in $files; do
      echo "Processing file: $file"
      process_batch "$file"
    done

    echo "Import completed for context ID: $CONTEXT_ID"
  fi
}

# Main function
main() {
  parse_arguments "$@"
  validate_parameters

  echo "Using context ID: $CONTEXT_ID"
  export_data
  import_data
}

# Execute main function
main "$@"