on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  validate-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check docs folder exists
        run: |
          if [ ! -d "docs" ]; then
            echo "Error: docs folder not found"
            exit 1
          fi

      - name: Check ERD file exists
        run: |
          if [ ! -f "docs/ERD.png" ] && [ ! -f "docs/ERD.pdf" ]; then
            echo "Error: ERD file not found"
            exit 1
          fi

      - name: Check Endpoint Plan exists
        run: |
          if [ ! -f "docs/EndpointPlan.md" ] && [ ! -f "docs/EndpointPlan.pdf" ]; then
            echo "Error: Endpoint Plan not found"
            exit 1
          fi

      - name: Check SQL Script exists
        run: |
          if [ ! -f "docs/RaceDayDB.sql" ]; then
            echo "Error: SQL script not found"
            exit 1
          fi

      - name: Validate SQL script contains CREATE statements
        run: |
          if ! grep -q "CREATE TABLE" docs/RaceDayDB.sql; then
            echo "Error: SQL script missing CREATE TABLE statements"
            exit 1
          fi

      - name: Success
        run: echo "All Part 1 validation checks passed!"
