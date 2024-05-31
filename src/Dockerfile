FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

ENV PORT 5000

EXPOSE $PORT

CMD ["python", "(link unavailable)"]
