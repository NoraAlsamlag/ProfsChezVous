# api/tasks.py
from celery import shared_task
from django.utils import timezone
from .models import Cour

@shared_task
def update_course_status():
    now = timezone.now()
    courses = Cour.objects.filter(statut__in=['AV', 'EC'])
    for course in courses:
        course.update_statut()
