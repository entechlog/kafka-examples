# Dockerfile
FROM python:3.8

WORKDIR /usr/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["faust", "-A", "app", "worker", "-l", "info"]
