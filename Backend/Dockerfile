# API SPHEREx (FastAPI). Reutiliza Database/scripts, por eso el contexto de build es la raíz del repo.
FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1 CYGNUSX_CACHE_DIR=/data/cache MPLBACKEND=Agg MPLCONFIGDIR=/tmp/mpl
WORKDIR /srv
COPY Backend/requirements.txt Backend/requirements.txt
RUN pip install -r Backend/requirements.txt
COPY Backend Backend
COPY Database/scripts Database/scripts
COPY Database/data Database/data
WORKDIR /srv/Backend
RUN mkdir -p /data/cache && useradd -m -u 10001 app && chown -R app /data /srv
USER app
EXPOSE 8000
HEALTHCHECK --interval=20s --timeout=5s --start-period=40s --retries=5 \
  CMD python -c "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:8000/api/health',timeout=4).status==200 else 1)"
# --proxy-headers: las URLs absolutas salen con el dominio/puerto público que ve el navegador.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--proxy-headers", "--forwarded-allow-ips", "*"]
