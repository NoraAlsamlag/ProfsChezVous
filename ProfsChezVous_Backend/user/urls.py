from django.urls import path, include
from . import views
from user.views import ParentRegisterView, ProfesseurRegisterView, EleveRegisterView, AdminRegisterView
urlpatterns = [
    path('register/parent/', ParentRegisterView.as_view(), name='parent_register'),
    path('register/professeur/', ProfesseurRegisterView.as_view(), name='professeur_register'),
    path('register/eleve/', EleveRegisterView.as_view(), name='eleve_register'),
    path('register/admin/', AdminRegisterView.as_view(), name='admin_register'),
    path('parentes/',views.getParents),
    path('parente/creer',views.createParent),
    path('parente/<str:pk>/mettre-a-jour',views.updateParent),
    path('parente/<str:pk>/supprimer',views.deleteParent),
    path('parente/<str:pk>',views.getParent),
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
]