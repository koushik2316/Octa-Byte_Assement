FROM python:3.10-slim

WORKDIR /app

# Install required system packages
RUN apt-get update && \
    apt-get install -y gcc libpq-dev curl --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and setuptools
RUN pip install --no-cache-dir --upgrade pip==23.3 setuptools==78.1.1

COPY requirements.txt .

# Install Python dependencies as root
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Add non-root user after all install steps
RUN adduser --disabled-password --gecos "" appuser
USER appuser

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
