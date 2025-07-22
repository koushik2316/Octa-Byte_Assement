FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y gcc libpq-dev curl --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip==23.3 setuptools==78.1.1

COPY requirements.txt .

# Create user BEFORE installing so pip installs into their environment
RUN adduser --disabled-password --gecos "" appuser
USER appuser

# Install requirements as appuser
RUN pip install --no-cache-dir --user -r requirements.txt

COPY . .

ENV PATH="/home/appuser/.local/bin:$PATH"

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
