from django.urls import path, include
from . import views
urlpatterns = [
    path('',views.getRoutes),
    path('parentes/',views.getParents),
    path('parente/creer',views.createParent),
    path('parente/<str:pk>/mettre-a-jour',views.updateParent),
    path('parente/<str:pk>/supprimer',views.deleteParent),
    path('parente/<str:pk>',views.getParent),
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
]