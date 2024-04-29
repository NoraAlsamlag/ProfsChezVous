from django.urls import path, include
from . import views
from .views import geocode_parent_address
<<<<<<< HEAD
from user.views import ParentRegisterView, ProfesseurRegisterView, EleveRegisterView, AdminRegisterView 

=======
from user.views import *
>>>>>>> 5f94715f5b7ee5601577a42c74d1b2d633e3f910
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
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
    path('geocode-parent/<int:parent_id>/', geocode_parent_address, name='geocode_parent'),
    
    #path('transactions/', views.TransactionListView.as_view(), name='transaction-list'),
    #path('transactions/<int:pk>/', views.TransactionDetailView.as_view(), name='transaction-detail'), 
   
]