flowchart TD
U[Local Entrepreneur / Foreign Investor] --> FE[Web Frontend]
FE --> API[Backend API]
API --> CHAT[AI Chatbot Service]
CHAT --> RAG[RAG Retrieval]
RAG --> VDB[(Vector Database)]
RAG --> KB[Verified Knowledge Base]
API --> DB[(PostgreSQL)]
API --> BC[EVM Smart Contract Registry]
ADMIN[Admin / Reviewer] --> API
ADMIN --> KB
KB --> STORAGE[Off-chain Source Snapshot Storage]
FE --> VERIFY[Verification Page]
VERIFY --> BC
