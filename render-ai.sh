#!/bin/bash
# Deploy the AI (FastAPI) service to Render.
# Run AFTER the feature branch has been merged to main.
#
# Required environment variables:
#   RENDER_API_KEY        - Render API bearer token
#   DATABASE_URL          - PostgreSQL connection string
#   DEEPSEEK_API_KEY      - DeepSeek LLM API key
#   EMBEDDING_API_KEY     - Voyage AI embedding API key
set -euo pipefail

: "${RENDER_API_KEY:?Missing RENDER_API_KEY}"
: "${DATABASE_URL:?Missing DATABASE_URL}"
: "${DEEPSEEK_API_KEY:?Missing DEEPSEEK_API_KEY}"
: "${EMBEDDING_API_KEY:?Missing EMBEDDING_API_KEY}"

curl -s -X POST https://api.render.com/v1/services \
  -H "Authorization: Bearer ${RENDER_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"web_service\",
    \"name\": \"bizguide-ai\",
    \"ownerId\": \"tea-ctc5ei9u0jms73cr1i20\",
    \"repo\": \"https://github.com/MAWOW1000/da-nang-bizguide-ai\",
    \"branch\": \"main\",
    \"autoDeploy\": \"yes\",
    \"serviceDetails\": {
      \"plan\": \"free\",
      \"env\": \"python\",
      \"envSpecificDetails\": {
        \"buildCommand\": \"pip install -e .\",
        \"startCommand\": \"uvicorn app.main:app --host 0.0.0.0 --port \$PORT\"
      },
      \"envVars\": [
        {\"key\": \"DATABASE_URL\", \"value\": \"${DATABASE_URL}\"},
        {\"key\": \"DEEPSEEK_API_KEY\", \"value\": \"${DEEPSEEK_API_KEY}\"},
        {\"key\": \"EMBEDDING_API_KEY\", \"value\": \"${EMBEDDING_API_KEY}\"},
        {\"key\": \"EMBEDDING_PROVIDER\", \"value\": \"voyage\"},
        {\"key\": \"AGENT_ENABLED\", \"value\": \"true\"},
        {\"key\": \"PYTHON_VERSION\", \"value\": \"3.12.3\"}
      ]
    }
  }"
