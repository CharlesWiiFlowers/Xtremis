FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
WORKDIR /app
COPY python/requirements.txt .
RUN pip install -r requirements.txt
COPY python/app ./app
EXPOSE 8001
# Arranca la API aun si MySQL tarda; el seed se ejecuta en background con reintentos
# y no puede bloquear las consultas TAP o el estado de salud.
CMD ["sh", "-c", "(until python -m app.seed; do echo 'MySQL no listo; reintento seed en 10s'; sleep 10; done) & uvicorn app.main:app --host 0.0.0.0 --port 8001"]
