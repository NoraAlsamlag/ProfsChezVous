from rest_framework.decorators import api_view
from rest_framework import generics
from rest_framework.response import Response
from api.serializers import  *
from .models import *
import requests
from django.http import JsonResponse
import requests
from .models import Parent
from rest_framework.decorators import api_view
from rest_framework.response import Response
import googlemaps
from django.conf import settings
from .models import Parent
import googlemaps
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Parent
from rest_framework import generics
from .models import Enfant
from .serializers import EnfantSerializer





from dj_rest_auth.registration.views import RegisterView
from user.serializers import ParentRegisterSerializer, ProfesseurRegisterSerializer, EleveRegisterSerializer, AdminRegisterSerializer 
import json

class ParentRegisterView(RegisterView):
    serializer_class = ParentRegisterSerializer
    

class ProfesseurRegisterView(RegisterView):
    serializer_class = ProfesseurRegisterSerializer

class EleveRegisterView(RegisterView):
    serializer_class = EleveRegisterSerializer

class AdminRegisterView(RegisterView):
    serializer_class = AdminRegisterSerializer

@api_view(['GET'])
def getParents(request):
    parents= Parent.objects.all()
    serializer = ParentSerializer(parents, many=True)
    return  Response(serializer.data)

@api_view(['GET'])
def getParent(request, pk):
    parent= Parent.objects.get(id=pk) 
    serializer = ParentSerializer(parent, many=False)
    return  Response(serializer.data)

@api_view(["POST"])
def createParent(request):
    serializer = ParentSerializer(data=request.data)
    if serializer.is_valid():
        parent = serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)


@api_view(["PUT"])
def updateParent(request, pk):
    try:
        parent = Parent.objects.get(id=pk)
    except Parent.DoesNotExist:
        return Response({"error": "Parent non trouvé"}, status=404)

    serializer = ParentSerializer(parent, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=400)


@api_view(["DELETE"])
def deleteParent(request, pk):
    parent = Parent.objects.get(id=pk)

    parent.delete()
    return Response("Parent supprimé")


@api_view(['GET'])
def geocode_parent_address(request, parent_id):
    parent = Parent.objects.get(id=parent_id)
    address = f"{parent.adresse}, {parent.ville}"  # Adresse complète à géocoder
    api_key = '0791-8482-2557'  # Clé API Google Maps Geocoding

    url = f'https://maps.googleapis.com/maps/api/geocode/json?address={address}&key={api_key}'
    response = requests.get(url)
    data = response.json()

    if data['status'] == 'OK':
        # Extraire les coordonnées de latitude et de longitude
        location = data['results'][0]['geometry']['location']
        latitude = location['lat']
        longitude = location['lng']
        # Mettre à jour les champs de géolocalisation du parent
        parent.latitude = latitude
        parent.longitude = longitude
        parent.save()
        return Response({'success': True})
    else:
        return Response({'success': False, 'message': 'Erreur de géocodage'})

def geocode_parent_address(parent):
    address = f"{parent.adresse}, {parent.ville}, {parent.pays}"  # Utilisez les champs appropriés de votre modèle Parent
    gmaps = googlemaps.Client(key=settings.GOOGLE_MAPS_API_KEY)
    geocode_result = gmaps.geocode(address)
    if geocode_result:
        location = geocode_result[0]['geometry']['location']
        latitude, longitude = location['lat'], location['lng']
        parent.latitude = latitude
        parent.longitude = longitude
        parent.save()
        return True
    else:
        return False
    
    
class EnfantListCreateAPIView(generics.ListCreateAPIView):
    queryset = Enfant.objects.all()
    serializer_class = EnfantSerializer

class EnfantRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Enfant.objects.all()
    serializer_class = EnfantSerializer