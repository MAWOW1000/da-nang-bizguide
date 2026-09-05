#!/bin/bash
# Create the Frontend (Next.js) project on Vercel.
# Vercel deploys from the default branch (main) automatically.
#
# Required environment variables:
#   VERCEL_TOKEN              - Vercel personal access token
#   NEXT_PUBLIC_API_BASE_URL  - Backend API URL (defaults to Render URL)
set -euo pipefail

: "${VERCEL_TOKEN:?Missing VERCEL_TOKEN}"
API_URL="${NEXT_PUBLIC_API_BASE_URL:-https://bizguide-backend.onrender.com}"

curl -s -X POST https://api.vercel.com/v9/projects \
  -H "Authorization: Bearer ${VERCEL_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"bizguide-frontend\",
    \"framework\": \"nextjs\",
    \"gitRepository\": {
      \"repo\": \"MAWOW1000/da-nang-bizguide-frontend\",
      \"type\": \"github\"
    },
    \"environmentVariables\": [
      {
        \"key\": \"NEXT_PUBLIC_API_BASE_URL\",
        \"value\": \"${API_URL}\",
        \"target\": [\"production\", \"preview\", \"development\"],
        \"type\": \"plain\"
      },
      {
        \"key\": \"NEXT_PUBLIC_API_URL\",
        \"value\": \"${API_URL}\",
        \"target\": [\"production\", \"preview\", \"development\"],
        \"type\": \"plain\"
      }
    ]
  }"
