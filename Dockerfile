FROM python:3.11.3-slim-bullseye as builder

WORKDIR /builder
RUN --mount=type=cache,target=/root/.cache pip3 install poetry

COPY . .

# projects api
COPY poetry.toml projects/api
RUN --mount=type=cache,target=/root/.cache poetry install -C projects/api




# runtime
FROM python:3.11.3-slim-bullseye as projects-api

WORKDIR /projects/api

ENV VIRTUAL_ENV=/projects/api/.venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"


COPY --from=builder /builder/projects/api .
RUN python -c "from src.projects.api.scripts import download; download()"

EXPOSE 8000
CMD ["python", "-m", "uvicorn", "src.projects.api.main:app", "--host", "0.0.0.0", "--port", "8000"]