# apps/ai-worker/Dockerfile
FROM python:3.11-slim AS base
WORKDIR /app

# Install system dependencies for sentence-transformers
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# --no-cache-dir: don't store pip cache in image (keeps image smaller)
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/

EXPOSE 8000
# uvicorn: production-grade ASGI server for FastAPI
# --reload: hot reload in development (remove in production)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]