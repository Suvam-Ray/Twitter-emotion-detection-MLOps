# Stage 1: Build Stage
FROM python:3.10 AS build
WORKDIR /app

# Ensure consistent NLTK path
ENV NLTK_DATA=/usr/local/nltk_data

# Copy needed files (includes requirements.txt inside flask_app)
COPY flask_app/ /app/
COPY models/vectorizer.pkl /app/models/vectorizer.pkl

# Create venv, install deps, download nltk data in ONE layer
RUN python -m venv /venv && \
    /venv/bin/pip install --no-cache-dir -r requirements.txt && \
    /venv/bin/python -m nltk.downloader -d /usr/local/nltk_data stopwords wordnet

ENV PATH="/venv/bin:$PATH"


# Stage 2: Final Stage
FROM python:3.10-slim
WORKDIR /app

ENV PATH="/venv/bin:$PATH" \
    NLTK_DATA=/usr/local/nltk_data

# Copy venv, nltk data and app
COPY --from=build /venv /venv
COPY --from=build /usr/local/nltk_data /usr/local/nltk_data
COPY --from=build /app /app

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "120", "app:app"]
