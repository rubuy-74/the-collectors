#!/bin/bash

# SingleStore connection details
HOST="svc-3482219c-a389-4079-b18b-d50662524e8a-shared-dml.aws-virginia-6.svc.singlestore.com"
PORT="80"  # Try 80 for HTTP or 443 for HTTPS
DATABASE="db_rubem_96de5"
USERNAME="your_username"
PASSWORD="your_password"
PROTOCOL="http"  # Use "https" if needed

# Create basic auth header
BASIC_AUTH=$(echo -n "$USERNAME:$PASSWORD" | base64)

# Function to test different endpoints
test_endpoint() {
    local url="$1"
    local data="$2"
    
    echo "Testing endpoint: $url"
    echo "Request data: $data"
    
    # Use -k flag to ignore SSL certificate validation if needed
    curl -s -X POST --http0.9 "$url" \
        -H "Authorization: Basic $BASIC_AUTH" \
        -H "Content-Type: application/json" \
        -d "$data" \
        --connect-timeout 10 \
        -v  # Verbose output to see connection details
}


# Test on different port (3333)
echo -e "\n\nTesting on port 3333..."
test_endpoint "$PROTOCOL://$HOST:3333/api/v2/query/$DATABASE" '{"sql":"SELECT 1"}'
