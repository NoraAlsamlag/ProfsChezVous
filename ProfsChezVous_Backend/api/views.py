from rest_framework import serializers, viewsets
from rest_framework import viewsets
from .models import CommentaireCours, Cours_Unite, Cours_Package
from api.serializers import  *
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from .models import *
from django.http import JsonResponse
import requests
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from rest_framework import status
from rest_framework.views import APIView
from rest_framework import generics
from .views import *
from django.views.generic import ListView
from rest_framework.generics import ListAPIView
from .models import Matiere
from .serializers import MatiereSerializer

class MatiereListView(ListAPIView):
    queryset = Matiere.objects.all()
    serializer_class = MatiereSerializer

class CoursUniteListView(ListAPIView):
    queryset = Matiere.objects.all()
    serializer_class = CoursUniteSerializer
    

class CoursPackageListView(ListAPIView):
    queryset = Matiere.objects.all()
    serializer_class = CoursPackageSerializer
    

class CommentaireCoursSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommentaireCours
        fields = '__all__'

class CommentaireCoursViewSet(viewsets.ModelViewSet):
    queryset = CommentaireCours.objects.all()
    serializer_class = CommentaireCoursSerializer

class CoursUniteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cours_Unite
        fields = '__all__'

class CoursUniteViewSet(viewsets.ModelViewSet):
    queryset = Cours_Unite.objects.all()
    serializer_class = CoursUniteSerializer

class CoursPackageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cours_Package
        fields = '__all__'

class CoursPackageViewSet(viewsets.ModelViewSet):
    queryset = Cours_Package.objects.all()
    serializer_class = CoursPackageSerializer
