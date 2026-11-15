# Servicio de consultas en vivo a Gaia (MAST), WISE y SPHEREx (IRSA) + carga del catálogo en MySQL.
FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1 CATALOG_PATH=/catalog/api_catalog.json
WORKDIR /app
COPY python/requirements.txt .
RUN pip install -r requirements.txt
COPY python/app ./app
COPY catalog /catalog
RUN useradd -m -u 10001 app && chown -R app /app
USER app
EXPOSE 8001
HEALTHCHECK --interval=15s --timeout=4s --start-period=15s --retries=5 \
  CMD python -c "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:8001/health',timeout=3).status==200 else 1)"
# La API arranca aunque MySQL tarde; el seed del catálogo reintenta en segundo plano.
CMD ["sh", "-c", "(until python -m app.seed; do echo 'MySQL no listo; reintento seed en 10s'; sleep 10; done) & exec uvicorn app.main:app --host 0.0.0.0 --port 8001"]
