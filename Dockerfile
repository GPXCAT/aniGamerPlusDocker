FROM python:3.8-slim

RUN apt update && \
    apt install -y git g++ gcc make libevent-dev libffi-dev libxml2-dev libxslt-dev zlib1g-dev ffmpeg && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone https://github.com/miyouzi/aniGamerPlus.git /app

RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "python3", "-u", "aniGamerPlus.py" ]
