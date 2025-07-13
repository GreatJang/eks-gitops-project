FROM python:3.9-slim

WORKDIR /app
COPY ./app /app

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "main:app"]