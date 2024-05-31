FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN apt-get update && \
    apt-get install -y python3 && \
    pip install -r requirements.txt

COPY . .

ENV PORT 5000

EXPOSE $PORT

CMD ["python", "app.py"]
