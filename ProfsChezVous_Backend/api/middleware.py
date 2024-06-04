import threading
import time
from django.utils import timezone
from api.models import Cour

class CourseStatusUpdater:
    def __init__(self):
        self.interval = 60
        self.thread = threading.Thread(target=self.run, daemon=True)
        self.thread.start()

    def run(self):
        while True:
            self.update_course_statuses()
            time.sleep(self.interval)

    def update_course_statuses(self):
        now = timezone.now()
        courses = Cour.objects.filter(statut__in=['AV', 'EC'])
        for course in courses:
            course.update_statut()

class CourseStatusUpdaterMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response
        self.updater = CourseStatusUpdater()

    def __call__(self, request):
        response = self.get_response(request)
        return response
