from django.urls import path, include
from . import views
# from .views import geocode_parent_address
from user.views import ParentRegisterView, ProfesseurRegisterView, EleveRegisterView, AdminRegisterView 
from dj_rest_auth.views import UserDetailsView
from .serializers import CustomUserDetailsSerializer

from user.views import *
urlpatterns = [
    path('register/parent/', ParentRegisterView.as_view(), name='parent_register'),
    path('register/professeur/', ProfesseurRegisterView.as_view(), name='professeur_register'),
    path('register/eleve/', EleveRegisterView.as_view(), name='eleve_register'),
    path('register/admin/', AdminRegisterView.as_view(), name='admin_register'),
    # path('parentes/',views.getParents),
    # path('parente/creer',views.createParent),
    # path('parente/<str:pk>/mettre-a-jour',views.updateParent),
    # path('parente/<str:pk>/supprimer',views.deleteParent),
    path('get_user_info/<int:user_pk>/', views.get_user_info, name='get_info_by_user_pk'),
    path('auth/user/', UserDetailsView.as_view(serializer_class=CustomUserDetailsSerializer), name='user-details'),
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
    # path('geocode-parent/<int:parent_id>/', geocode_parent_address, name='geocode_parent'),
    
    #path('transactions/', views.TransactionListView.as_view(), name='transaction-list'),
    #path('transactions/<int:pk>/', views.TransactionDetailView.as_view(), name='transaction-detail'), 
   
    path('enfants/', views.EnfantListCreateAPIView.as_view(), name='enfant-list-create'),
    path('enfants/<int:pk>/', views.EnfantRetrieveUpdateDestroyAPIView.as_view(), name='enfant-detail'),
    # path('obtenir-adresse/', views.obtenir_adresse_a_partir_des_coordonnees, name='obtenir_adresse'),
    path('ajouter-ou-modifier-photo-profil/<int:user_pk>/', views.ajouter_ou_modifier_photo_profil, name='ajouter_ou_modifier_photo_profil'),
    path('obtenir_informations_utilisateur/', fetch_user, name='fetch_user'),
    path('verifier-email/<str:email>/', EmailCheckAPIView.as_view(), name='verifier_email'),
    path('professeurs/', get_professeur, name='professeurs'),
]