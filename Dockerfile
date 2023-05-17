FROM python:3.11.3-slim-buster

RUN mkdir -p /app
WORKDIR /app

COPY . .

ENV PYTHONPATH=${PYTHONPATH}:${PWD} 
RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev

EXPOSE 8080

CMD ["uvicorn", "src:app", "--host", "0.0.0.0", "--port", "8080"]