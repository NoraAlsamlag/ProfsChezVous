from django.urls import path, include
from . import views
from .views import geocode_parent_address
from user.views import ParentRegisterView, ProfesseurRegisterView, EleveRegisterView, AdminRegisterView
from user.views import *
urlpatterns = [
    path('register/parent/', ParentRegisterView.as_view(), name='parent_register'),
    path('register/professeur/', ProfesseurRegisterView.as_view(), name='professeur_register'),
    path('register/eleve/', EleveRegisterView.as_view(), name='eleve_register'),
    path('register/admin/', AdminRegisterView.as_view(), name='admin_register'),
    path('info/', views.get_user_by_token, name='user_info'),
    path('parent/info/', views.ParentViewSet.as_view({'get': 'list'}), name='parent_info'),
    path('professeur/info/', views.ProfesseurViewSet.as_view({'get': 'list'}), name='professeur_info'),
    path('eleve/info/', views.EleveViewSet.as_view({'get': 'list'}), name='eleve_info'),
    # path('parentes/',views.getParents),
    # path('parente/creer',views.createParent),
    # path('parente/<str:pk>/mettre-a-jour',views.updateParent),
    # path('parente/<str:pk>/supprimer',views.deleteParent),
    path('get_user_info/<int:user_pk>/', views.get_user_info, name='get_info_by_user_pk'),
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
    path('geocode-parent/<int:parent_id>/', geocode_parent_address, name='geocode_parent'),
    path('enfants/', views.EnfantListCreateAPIView.as_view(), name='enfant-list-create'),
    path('enfants/<int:pk>/', views.EnfantRetrieveUpdateDestroyAPIView.as_view(), name='enfant-detail'),
]