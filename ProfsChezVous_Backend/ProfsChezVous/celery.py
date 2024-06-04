# ProfsChezVous/celery.py
from __future__ import absolute_import, unicode_literals
import os
from celery import Celery
from celery.schedules import crontab

# Set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ProfsChezVous.settings')

app = Celery('ProfsChezVous')

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
# namespace='CELERY' means all celery-related configuration keys
# should have a `CELERY_` prefix.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Load task modules from all registered Django app configs.
app.autodiscover_tasks()

@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')

# Define the beat schedule for periodic tasks
app.conf.beat_schedule = {
    'update-course-status-every-minute': {
        'task': 'api.tasks.update_course_status',
        'schedule': crontab(),  # This means every minute
    },
}
