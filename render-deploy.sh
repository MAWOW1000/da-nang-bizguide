#!/bin/bash
# Deploy the Backend (NestJS) service to Render.
# Run AFTER the feature branch has been merged to main.
#
# Required environment variables:
#   RENDER_API_KEY        - Render API bearer token
#   DATABASE_URL          - PostgreSQL connection string
#   AI_SERVICE_URL        - URL of the deployed AI service
#   FRONTEND_ORIGIN       - URL of the deployed frontend (for CORS)
set -euo pipefail

: "${RENDER_API_KEY:?Missing RENDER_API_KEY}"
: "${DATABASE_URL:?Missing DATABASE_URL}"
AI_SERVICE_URL="${AI_SERVICE_URL:-https://bizguide-ai.onrender.com}"
FRONTEND_ORIGIN="${FRONTEND_ORIGIN:-https://bizguide-frontend.vercel.app}"

curl -s -X POST https://api.render.com/v1/services \
  -H "Authorization: Bearer ${RENDER_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"web_service\",
    \"name\": \"bizguide-backend\",
    \"ownerId\": \"tea-ctc5ei9u0jms73cr1i20\",
    \"repo\": \"https://github.com/MAWOW1000/da-nang-bizguide-backend\",
    \"branch\": \"main\",
    \"autoDeploy\": \"yes\",
    \"serviceDetails\": {
      \"plan\": \"free\",
      \"env\": \"node\",
      \"envSpecificDetails\": {
        \"buildCommand\": \"npm install --include=dev && npx prisma generate && npm run build\",
        \"startCommand\": \"npm run start:prod\"
      },
      \"envVars\": [
        {\"key\": \"DATABASE_URL\", \"value\": \"${DATABASE_URL}\"},
        {\"key\": \"NODE_ENV\", \"value\": \"production\"},
        {\"key\": \"AI_SERVICE_URL\", \"value\": \"${AI_SERVICE_URL}\"},
        {\"key\": \"FRONTEND_ORIGIN\", \"value\": \"${FRONTEND_ORIGIN}\"},
        {\"key\": \"NODE_VERSION\", \"value\": \"22.14.0\"}
      ]
    }
  }"
