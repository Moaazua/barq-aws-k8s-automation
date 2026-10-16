FROM python:3.12-slim-bookworm@sha256:782412e85d0f0984994c290652577d4018aff08145c85b262bb63dc0c7522254
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /srv
RUN groupadd --gid 10001 app && useradd --uid 10001 --gid app --no-create-home app
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY --chown=app:app app/ ./app/
USER app
EXPOSE 8080
CMD ["python", "-m", "app.server"]
