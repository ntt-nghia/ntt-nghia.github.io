---
layout: post
title: "DynamoDB Sync Tool: A Comprehensive Guide"
date: 2025-05-06 08:00:00 +0700
tags: [aws, dynamodb, devops, shell-scripting]
isPublished: true
---

# DynamoDB Sync Tool: A Comprehensive Guide

When working with DynamoDB in a development environment, you often need to sync data between your production database and your local setup. This operation is essential for debugging, testing with real data, and reproducing issues that only occur with specific data patterns. Today I'll walk you through a powerful Bash script I've created that solves this common challenge.

## The Problem

As developers, we often face these challenges when working with DynamoDB:

1. Need to test with realistic data during local development
2. Reproducing bugs that only happen with production data
3. Backing up specific data subsets from production
4. Seeding a test environment with controlled data samples

The typical approaches often involve complex AWS CLI commands, multiple steps, or writing custom code for each specific use case. This leads to inconsistent processes across the team and time wasted on reinventing the wheel.

## The Solution: DynamoDB Sync Tool

I've developed a versatile Bash script that simplifies the process of exporting data from a remote DynamoDB table and importing it into a local DynamoDB instance. The script supports various query patterns, filtering options, and can be used for either export-only or import-only operations.

Let's look at how to use it.

## How to Use the Script

### Basic Usage

At its simplest, you can use the script like this:

```bash
./dynamodb-sync.sh --table users --pk user123
```

This will:
1. Connect to your AWS DynamoDB table named "users"
2. Query for items with partition key "user123"
3. Export the results to a JSON file
4. Import those items to your local DynamoDB

### Advanced Options

The script supports many options to give you precise control:

```bash
./dynamodb-sync.sh \
  --table users \
  --operation query \
  --pk user123 \
  --filter "age > :age" \
  --attributes '{":age":{"N":"18"}}' \
  --index email-index \
  --projection "id, name, email" \
  --local-table local-users
```

This more complex example:
1. Queries the "users" table
2. Looks for items with partition key "user123"
3. Filters for users with age > 18
4. Uses a secondary index called "email-index"
5. Only retrieves the "id", "name", and "email" attributes
6. Imports into a different local table named "local-users"

### Scanning Instead of Querying

If you need to scan the entire table rather than query by key:

```bash
./dynamodb-sync.sh \
  --table users \
  --operation scan \
  --filter "status = :status" \
  --attributes '{":status":{"S":"active"}}' \
  --max-items 2000
```

### Export or Import Only

You can also choose to only export or only import:

```bash
# Export only
./dynamodb-sync.sh --table users --pk user123 --export-only

# Import previously exported files
./dynamodb-sync.sh --table users --context-id 20250506120000 --import-only
```

## Understanding the Script Structure

The script is organized into several functions, each handling a specific part of the process:

1. **show_help()**: Displays usage information
2. **parse_arguments()**: Processes command-line arguments
3. **validate_parameters()**: Ensures required parameters are provided
4. **build_aws_command()**: Constructs the AWS CLI command dynamically
5. **export_data()**: Handles the export process
6. **process_batch()**: Processes items in batches for import
7. **import_data()**: Handles the import process
8. **main()**: Coordinates the overall execution

Let's examine each part to understand how it works and how you might modify it for your needs.

### Command-Line Arguments

The script accepts numerous parameters to customize its behavior:

- `--table, -t`: Source DynamoDB table name
- `--region, -r`: AWS region
- `--max-items, -m`: Maximum items per batch
- `--local-url, -l`: Local DynamoDB URL
- `--local-table, -lt`: Local DynamoDB table name
- `--operation, -o`: DynamoDB operation (query or scan)
- `--pk`: Partition key value
- `--sk`: Sort key value
- `--filter, -f`: Filter expression
- `--attributes, -a`: Expression attribute values as JSON
- `--index, -i`: Secondary index to use
- `--projection, -p`: Projection expression
- `--context-id, -c`: Unique context ID
- `--export-only, -e`: Only export data
- `--import-only`: Only import existing files

### The Export Process

The export function queries or scans DynamoDB and saves the results to JSON files:

1. It constructs an AWS CLI command based on your parameters
2. Executes the command and captures the output
3. Saves the results to a file with the context ID and batch number
4. If there are more results (via NextToken), it continues fetching until complete

### The Import Process

The import function reads the exported JSON files and imports them to your local DynamoDB:

1. Locates files matching the current context ID
2. For each file, extracts the items and processes them in batches of 25
3. Creates a temporary file with the batch-write-item format
4. Uses AWS CLI to import the items
5. Removes the temporary file

## Common Scenarios and Examples

### Scenario 1: Testing with Production User Data

You're debugging an issue that only occurs with specific user data:

```bash
./dynamodb-sync.sh --table users --pk user456 --sk profile
```

### Scenario 2: Analyzing Order Patterns

You want to analyze recent orders for a product category:

```bash
./dynamodb-sync.sh \
  --table orders \
  --operation scan \
  --filter "category = :cat AND orderDate > :date" \
  --attributes '{":cat":{"S":"electronics"},":date":{"S":"2025-04-01"}}'
```

### Scenario 3: Periodic Backups

Set up a cron job to back up critical data daily:

```bash
0 1 * * * /path/to/dynamodb-sync.sh \
  --table critical-data \
  --operation scan \
  --export-only \
  --context-id "backup-$(date +\%Y\%m\%d)"
```

## Customization Tips

### Custom Key Names

If your table uses different key names than "pk" and "sk", you'll need to modify the `build_aws_command()` function to use your key names.

### Additional AWS Parameters

You can extend the script to support additional AWS CLI parameters by adding new command-line options and incorporating them into the `build_aws_command()` function.

### Error Handling

For production use, you might want to enhance the error handling and add logging capabilities.

## Prerequisites

To use this script, you'll need:

1. AWS CLI installed and configured with appropriate credentials
2. jq installed for JSON processing
3. A running local DynamoDB instance
4. Appropriate IAM permissions to read from the source table

## Conclusion

The DynamoDB Sync Tool simplifies what would otherwise be a complex, error-prone process. It allows you to quickly sync data between environments without having to remember complex AWS CLI commands or write custom code every time.

By understanding how this script works, you can also adapt it to fit your specific needs or create similar utility scripts for other AWS services.

Feel free to share this tool with your team to establish a consistent approach to working with DynamoDB data across different environments.

## Download

Save the script as `dynamodb-sync.sh`, make it executable with `chmod +x dynamodb-sync.sh`, and you're ready to go!

Happy coding!