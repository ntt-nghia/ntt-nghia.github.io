---
layout: post
title: "DynamoDB Sync Tool: A Comprehensive Guide"
date: 2025-05-06 08:00:00 +0700
tags: [aws, dynamodb, devops, shell-scripting]
isPublished: true
---

This guide explains how to use the DynamoDB Sync Tool to migrate data between AWS DynamoDB and local environments.

## Quick Start

```bash
./dynamodb-sync.sh -h
```

Explore the arguments and usages

```bash
./dynamodb-sync.sh --table users --pk user123
```

This command fetches items with partition key "user123" from the "users" table and imports them to your local DynamoDB
instance.

## Core Parameters

| Parameter            | Description                                | Default               |
|----------------------|--------------------------------------------|-----------------------|
| `--table, -t`        | Source DynamoDB table name                 | source_table          |
| `--pk`               | Partition key value (required for queries) | -                     |
| `--operation, -o`    | Operation type: query or scan              | query                 |
| `--region, -r`       | AWS region                                 | ap-southeast-1        |
| `--local-url, -l`    | Local DynamoDB URL                         | http://localhost:4569 |
| `--local-table, -lt` | Local table name                           | local_table           |

## Advanced Query Options

```bash
./dynamodb-sync.sh \
  --table users \
  --pk user123 \
  --filter "age > :age" \
  --attributes '{":age":{"N":"18"}}' \
  --index email-index \
  --projection "id, name, email"
```

This queries users with partition key "user123", filters for age > 18, uses the email-index, and selects only specified
attributes.

## Table Scanning

For operations without a specific key:

```bash
./dynamodb-sync.sh \
  --table users \
  --operation scan \
  --filter "status = :status" \
  --attributes '{":status":{"S":"active"}}' \
  --max-items 500
```

## Export or Import Only

Export data without importing:

```bash
./dynamodb-sync.sh --table users --pk user123 --export-only
```

Import previously exported files:

```bash
./dynamodb-sync.sh --table users --context-id 20250506120000 --import-only
```

## Batch Processing

Control batch size for large datasets:

```bash
./dynamodb-sync.sh --table users --operation scan --max-items 2000
```

## Prerequisites

- AWS CLI installed and configured
- jq installed for JSON processing
- Running local DynamoDB instance
- Appropriate IAM permissions

## Common Use Cases

1. **Development**: Import real data for testing
2. **Debugging**: Reproduce issues with specific data patterns
3. **Backups**: Schedule exports via cron jobs
4. **Analysis**: Export filtered data subsets

The tool automatically handles pagination, processes items in batches, and provides progress feedback during operation.

## Download

- Save the script as [dynamodb-sync.sh](https://github.com/dodooh/dodooh.github.io/blob/master/resources/dynamodb-sync.sh),
- Make it executable with `chmod +x dynamodb-sync.sh`, and you're ready to go!
