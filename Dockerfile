# Base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies securely
RUN apt-get update && \
    apt-get install -y gcc libpq-dev curl --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the port
EXPOSE 5000

# Start the Flask app using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
