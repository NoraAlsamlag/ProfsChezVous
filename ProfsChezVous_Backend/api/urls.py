from django.urls import path, include
from . import views
from .views import CoursUniteViewSet
from rest_framework.routers import DefaultRouter
from rest_framework.routers import DefaultRouter
from .views import CoursPackageViewSet
from .views import DiscussionParentAdminViewSet




urlpatterns = [
    path('matieres/', views.MatiereList.as_view(), name='matiere-list'),
    path('matieres/<int:pk>/', views.MatiereDetail.as_view(), name='matiere-detail'),
    path('commentaires/', views.CommentaireCoursList.as_view(), name='commentaire-list'),
    path('commentaires/<int:pk>/', views.CommentaireCoursDetail.as_view(), name='commentaire-detail'),
    path('cours-unite/', CoursUniteViewSet.as_view({'get': 'list', 'post': 'create'}), name='cours-unite-list'),
    path('cours-unite/<int:pk>/', CoursUniteViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}), name='cours-unite-detail'),
    path('cours-package/', CoursPackageViewSet.as_view({'get': 'list', 'post': 'create'}), name='cours-package-list'),
    path('discussion-parent-admin/', DiscussionParentAdminViewSet.as_view({'get': 'list', 'post': 'create'}), name='discussion-parent-admin-list'),
    path('discussion-parent-admin/<int:pk>/', DiscussionParentAdminViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'}), name='discussion-parent-admin-detail'),
]
