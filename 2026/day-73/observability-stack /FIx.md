# Django + Prometheus Monitoring Setup (Fix Guide)

This guide explains how to fix the **`/metrics` endpoint issue** and the **Prometheus target error (Error scraping target: server returned HTTP status 404 Not Found)**, and how to integrate **Prometheus monitoring** into a Django Notes App running in Docker.
---

### Why this happens:

- Django app is running  
- API endpoints are working  
- `/metrics` endpoint is missing  

---

## Root Cause

- Prometheus integration package  
- `/metrics` endpoint configuration  
- Middleware for metrics collection 

---

# Solution

## Install Dependency

Add the following to your `requirements.txt`:

```txt
django-prometheus
```

## Update `notes-app/notesapp/settings.py`

Add to INSTALLED_APPS

`Important: Place django_prometheus at the top`

```bash
INSTALLED_APPS = [
    'django_prometheus',  # MUST be FIRST (important for instrumentation)

    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'api.apps.ApiConfig',
    'rest_framework',
    'corsheaders',
]
```
`Update MIDDLEWARE`

`Add Prometheus middleware at the top and bottom:`

```bash
MIDDLEWARE = [
    'django_prometheus.middleware.PrometheusBeforeMiddleware',  # MUST be FIRST

    'django.middleware.security.SecurityMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    "whitenoise.middleware.WhiteNoiseMiddleware",
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',

    # 'django.middleware.csrf.CsrfViewMiddleware',

    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',

    'django_prometheus.middleware.PrometheusAfterMiddleware',  # MUST be LAST
]
```

## Update notes-app/notesapp/urls.py

`Expose the /metrics endpoint:`

```bash
from django.contrib import admin
from django.urls import path, include
from django.views.generic import TemplateView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
    path('', TemplateView.as_view(template_name='index.html')),
    path('', include('django_prometheus.urls')), 
]
```

## Rebuild 
```bash
docker-compose up --build
```

## Test metrics endpoint
```bash
curl http://localhost:8000/metrics
```
