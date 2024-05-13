from django.urls import path, include
from . import views
from .views import CoursUniteViewSet
from rest_framework.routers import DefaultRouter
from .views import CoursPackageViewSet
#from .views import DiscussionParentAdminViewSet

from .views import MessageViewSet 

urlpatterns = [
    path('matieres/', views.MatiereList.as_view(), name='matiere-list'),
    path('matieres/<int:pk>/', views.MatiereDetail.as_view(), name='matiere-detail'),
    path('commentaires/', views.CommentaireCoursList.as_view(), name='commentaire-list'),
    path('commentaires/<int:pk>/', views.CommentaireCoursDetail.as_view(), name='commentaire-detail'),
    path('cours-unite/', CoursUniteViewSet.as_view({'get': 'list', 'post': 'create'}), name='cours-unite-list'),
    path('cours-unite/<int:pk>/', CoursUniteViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}), name='cours-unite-detail'),
    path('cours-package/', CoursPackageViewSet.as_view({'get': 'list', 'post': 'create'}), name='cours-package-list'),
    #path('discussion-parent-admin/', DiscussionParentAdminViewSet.as_view({'get': 'list', 'post': 'create'}), name='discussion-parent-admin-list'),
   # path('discussion-parent-admin/<int:pk>/', DiscussionParentAdminViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}), name='discussion-parent-admin-detail'),
  
    path('messages/', MessageViewSet.as_view({'get': 'list', 'post': 'create'}), name='message-list'),
    path('messages/<int:pk>/', MessageViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}), name='message-detail'),
    path('transactions/', views.TransactionListView.as_view(), name='transaction-list'),
    path('transactions/<int:pk>/', views.TransactionDetailView.as_view(), name='transaction-detail'),
    path('evaluations/', views.EvaluationListAPIView.as_view(), name='evaluation-list-create'),
    path('evaluations/<int:pk>/', views.EvaluationRetrieveUpdateDestroyAPIView.as_view(), name='evaluation-detail'),
   # path('diplomes/', views.DiplomeListCreateAPIView.as_view(), name='diplome-list-create'),
   # path('diplomes/<int:pk>/', views.DiplomeRetrieveUpdateDestroyAPIView.as_view(), name='diplome-detail'),
    path('cours/', views.CoursListCreateAPIView.as_view(), name='cours-list-create'),
    path('cours/<int:pk>/', views.CoursRetrieveUpdateDestroyAPIView.as_view(), name='cours-detail'),
    
    path('suivi-professeur/<int:pk>/', views.SuiviProfesseurRetrieveUpdateAPIView.as_view(), name='suivi-professeur-detail'),
    path('suivi-professeur/', views.SuiviProfesseurListAPIView.as_view(), name='suivi-professeur-list'),
    path('disponibilites/', views.DisponibiliteListCreateAPIView.as_view(), name='disponibilite_list_create'),
    path('disponibilites/<int:pk>/', views.DisponibiliteRetrieveUpdateDestroyAPIView.as_view(), name='disponibilite_detail'),

    path('cours/', views.CoursReserveListCreateAPIView.as_view(), name='cours_reserve_list_create'),
    path('cours/<int:pk>/',views. CoursReserveRetrieveUpdateDestroyAPIView.as_view(), name='cours_reserve_detail'),
    path('reserver-cours/', views.reserver_cours, name='reserver_cours'),
    path('signaler-absence/', views.signaler_absence, name='signaler_absence'),
    path('demander-remboursement/', views.demander_remboursement, name='demander_remboursement'),
    path('planifier-rattrapage/', views.planifier_rattrapage, name='planifier_rattrapage'),
    path('notifications/', views.NotificationListCreateAPIView.as_view(), name='notification-list-create'),
    path('notifications/<int:pk>/', views.NotificationRetrieveUpdateDestroyAPIView.as_view(), name='notification-detail'),
   

]
