from django.urls import path
from django.contrib.auth import views as auth_views

from . import views

urlpatterns = [
  path(''       , views.index,  name='index'),
  path('tables/', views.tables, name='tables'),
  path('toggle_user_status/<int:user_id>/', views.toggle_user_status, name='toggle_user_status'),
]
