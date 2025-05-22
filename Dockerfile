# syntax=docker/dockerfile:1

FROM python:3.11-slim

# 1) Set the working directory
WORKDIR /app

# 2) Copy only requirements first (caching)
COPY requirements.txt .

# 3) Install Python deps
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential \
 && pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && apt-get purge -y build-essential \
 && rm -rf /var/lib/apt/lists/*

# 4) Copy *all* application code into /app
#    (so x_client_transaction/ ends up at /app/x_client_transaction)
COPY . /app

# 5) Ensure /app is on PYTHONPATH
ENV PYTHONPATH=/app

# 6) Expose Uvicorn’s port and start the server
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
