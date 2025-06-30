ARG BUILDER=python:3.12-alpine
ARG RUNNER=python:3.12-alpine

FROM $BUILDER AS build
# RUN apt-get update
RUN apk update && apk upgrade

# Create a virtual environment that can be copied into the next stage
RUN python -m venv /venv

# Install packages into it
WORKDIR /app
COPY requirements.txt ./
RUN /venv/bin/pip install -r requirements.txt

FROM $RUNNER

RUN apk update && apk upgrade

WORKDIR /app/
COPY --from=build /venv/ /venv/
COPY server.py schemas.py database.py models.py  /app/
 
ENV PATH=/venv/bin:$PATH

RUN addgroup --gid 3000 fastgrp && \
    adduser -D --uid 1001 --ingroup fastgrp fastapi \
    && chown -R 1001:3000 /app
    
USER 1001:3000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]