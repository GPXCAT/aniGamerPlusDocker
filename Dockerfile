ARG python=python:3.8-slim-bullseye

# build stage
FROM ${python} AS build-env

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive && \
    apt install --no-install-recommends --assume-yes \
    git g++ gcc make libevent-dev libffi-dev libxml2-dev libxslt-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Create the virtual environment.
RUN python3 -m venv /venv
ENV PATH=/venv/bin:$PATH

WORKDIR /app
RUN git clone https://github.com/miyouzi/aniGamerPlus.git /app && \
    pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# final stage
FROM ${python}

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive && \
    apt install --no-install-recommends --assume-yes \
    ffmpeg && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build-env /venv /venv
COPY --from=build-env /app /app
ENV PATH=/venv/bin:$PATH

WORKDIR /app
ENTRYPOINT [ "python3", "-u", "aniGamerPlus.py" ]
