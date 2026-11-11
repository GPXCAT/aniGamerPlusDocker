ARG PYTHON_IMAGE=python:3.12-slim-bookworm

# 取得上游原始碼 (REF 可以是 branch / tag / commit)
FROM alpine/git AS source
ARG REPO=https://github.com/miyouzi/aniGamerPlus.git
ARG REF=master
RUN git clone --filter=blob:none "$REPO" /src && \
    git -C /src checkout "$REF" && \
    rm -rf /src/.git

# 安裝 Python 套件
FROM ${PYTHON_IMAGE} AS build
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        g++ gcc make libevent-dev libffi-dev libxml2-dev libxslt-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*
RUN python3 -m venv /venv
ENV PATH=/venv/bin:$PATH
COPY --from=source /src/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# 執行環境
FROM ${PYTHON_IMAGE}
ARG REF=master
LABEL org.opencontainers.image.source="https://github.com/miyouzi/aniGamerPlus" \
      org.opencontainers.image.revision="${REF}"
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*
COPY --from=build /venv /venv
COPY --from=source /src /app
ENV PATH=/venv/bin:$PATH \
    PYTHONDONTWRITEBYTECODE=1
WORKDIR /app
EXPOSE 5000
ENTRYPOINT ["python3", "-u", "aniGamerPlus.py"]
