from rest_framework.response import Response
from rest_framework import viewsets

from api.serializers import  *
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from .models import *
from django.http import JsonResponse
import requests
from .models import Parent
# import googlemaps
# import googlemaps
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from rest_framework import status
from rest_framework.views import APIView
from rest_framework import generics
from .models import Enfant
from .serializers import *

from dj_rest_auth.registration.views import RegisterView

from .serializers import EnfantSerializer


class ParentRegisterView(RegisterView):
    serializer_class = ParentRegisterSerializer
    

class ProfesseurRegisterView(RegisterView):
    serializer_class = ProfesseurRegisterSerializer

class EleveRegisterView(RegisterView):
    serializer_class = EleveRegisterSerializer

class AdminRegisterView(RegisterView):
    serializer_class = AdminRegisterSerializer






@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_by_token(request):
    user = request.user  # Retrieve user object from request
    serializer = UserSerializer(user)
    return JsonResponse(serializer.data)

class ParentViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def list(self, request):
        # Retrieve the user based on the token
        user = request.user
        # Check if the user is a parent
        if user.is_parent:
            # Get the parent information associated with the user
            parent = Parent.objects.get(user=user)
            # Serialize the parent information
            serializer = ParentSerializer(parent)
            return JsonResponse(serializer.data)
        else:
            return Response({"message": "L'utilisateur n'est pas un parent."}, status=status.HTTP_403_FORBIDDEN)
        


class EleveViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def list(self, request):
        user = request.user
        if user.is_eleve:
            eleve = Eleve.objects.get(user=user)
            serializer = EleveSerializer(eleve)
            return Response(serializer.data)
        else:
            return Response({"message": "L'utilisateur n'est pas un élève."}, status=403)

class ProfesseurViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def list(self, request):
        user = request.user
        if user.is_professeur:
            professeur = Professeur.objects.get(user=user)
            serializer = ProfesseurSerializer(professeur)
            return Response(serializer.data)
        else:
            return Response({"message": "L'utilisateur n'est pas un professeur."}, status=403)


# @api_view(['GET'])
# def getParents(request):
#     parents= Parent.objects.all()
#     serializer = ParentSerializer(parents, many=True)
#     return  Response(serializer.data)

# @api_view(['GET'])
# def getParent(request, pk):
#     parent= Parent.objects.get(id=pk) 
#     serializer = ParentSerializer(parent, many=False)
#     return  Response(serializer.data)

# @api_view(["POST"])
# def createParent(request):
#     serializer = ParentSerializer(data=request.data)
#     if serializer.is_valid():
#         parent = serializer.save()
#         return Response(serializer.data, status=201)
#     return Response(serializer.errors, status=400)


# @api_view(["PUT"])
# def updateParent(request, pk):
#     try:
#         parent = Parent.objects.get(id=pk)
#     except Parent.DoesNotExist:
#         return Response({"error": "Parent non trouvé"}, status=404)

#     serializer = ParentSerializer(parent, data=request.data)
#     if serializer.is_valid():
#         serializer.save()
#         return Response(serializer.data)
#     return Response(serializer.errors, status=400)


# @api_view(["DELETE"])
# def deleteParent(request, pk):
#     parent = Parent.objects.get(id=pk)

#     parent.delete()
#     return Response("Parent supprimé")


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



@api_view(['POST'])
def logout(request):
    # Delete the user's token
    request.user.auth_token.delete()
    return Response({"detail": "Successfully logged out."})





def get_user_info(request, user_pk):
    try:
        user = User.objects.get(pk=user_pk)
        if user.is_parent:
            parent = Parent.objects.get(user=user)
            return JsonResponse({'user_type': 'parent', 'details': parent.to_json()}, status=200)
        elif user.is_professeur:
            professeur = Professeur.objects.get(user=user)
            return JsonResponse({'user_type': 'professeur', 'details': professeur.to_json()}, status=200)
        elif user.is_eleve:
            eleve = Eleve.objects.get(user=user)
            return JsonResponse({'user_type': 'eleve', 'details': eleve.to_json()}, status=200)
        else:
            return JsonResponse({'error': 'Type d\'utilisateur non valide'}, status=400)
    except User.DoesNotExist:
        return JsonResponse({'error': 'Utilisateur non trouvé'}, status=404)
    except (Parent.DoesNotExist, Professeur.DoesNotExist, Eleve.DoesNotExist):
        return JsonResponse({'error': 'Détails de l\'utilisateur non trouvés'}, status=404)