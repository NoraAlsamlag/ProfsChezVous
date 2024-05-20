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
from django.shortcuts import get_object_or_404

#from user.models import User


#from .models import Transaction
#from .serializers import TransactionSerializer


from dj_rest_auth.registration.views import RegisterView

from .serializers import EnfantSerializer 







from dj_rest_auth.registration.views import RegisterView

class ParentRegisterView(RegisterView):
    serializer_class = ParentRegisterSerializer

    def perform_create(self, serializer):
        serializer.save(request=self.request)
    

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
# def geocode_parent_address(request, parent_id):
#     parent = Parent.objects.get(id=parent_id)
#     address = f"{parent.adresse}, {parent.ville}"  # Adresse complète à géocoder
#     api_key = '0791-8482-2557'  # Clé API Google Maps Geocoding

#     url = f'https://maps.googleapis.com/maps/api/geocode/json?address={address}&key={api_key}'
#     response = requests.get(url)
#     data = response.json()

#     if data['status'] == 'OK':
#         # Extraire les coordonnées de latitude et de longitude
#         location = data['results'][0]['geometry']['location']
#         latitude = location['lat']
#         longitude = location['lng']
#         # Mettre à jour les champs de géolocalisation du parent
#         parent.latitude = latitude
#         parent.longitude = longitude
#         parent.save()
#         return Response({'success': True})
#     else:
#         return Response({'success': False, 'message': 'Erreur de géocodage'})

# def geocode_parent_address(parent):
#     address = f"{parent.adresse}, {parent.ville}, {parent.pays}"  # Utilisez les champs appropriés de votre modèle Parent
#     gmaps = googlemaps.Client(key=settings.GOOGLE_MAPS_API_KEY)
#     geocode_result = gmaps.geocode(address)
#     if geocode_result:
#         location = geocode_result[0]['geometry']['location']
#         latitude, longitude = location['lat'], location['lng']
#         parent.latitude = latitude
#         parent.longitude = longitude
#         parent.save()
#         return True
#     else:
#         return False
    
    


    
class EnfantListCreateAPIView(generics.ListCreateAPIView):
    queryset = Enfant.objects.all()
    serializer_class = EnfantSerializer

class EnfantRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Enfant.objects.all()
    serializer_class = EnfantSerializer

class TransactionCreateAPIView(APIView):
    def post(self, request):
        serializer = TransactionSerializer(data=request.data)
        if serializer.is_valid():
            # Calcul des pourcentages à retenir par l'intermédiaire
            pourcentage_intermediaire = ... # Calcul du pourcentage
            # Enregistrement de la transaction
            serializer.save(pourcentage_intermediaire=pourcentage_intermediaire)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def logout(request):
    # Delete the user's token
    request.user.auth_token.delete()
    return Response({"detail": "Successfully logged out."})



def fetch_user(request):
    # Fetch the user data

    try:
        user = User.objects.get(id=request.user.id)
        if user.is_parent:
            parent = Parent.objects.get(user=user)
            return JsonResponse({'user_type': 'Paren','email': user.email,
        'image_profil': str(user.image_profil), 'details': parent.to_json()}, status=200)
        elif user.is_professeur:
            professeur = Professeur.objects.get(user=user)
            return JsonResponse({'user_type': 'Professeur','email': user.email,
        'image_profil': str(user.image_profil), 'details': professeur.to_json()}, status=200)
        elif user.is_eleve:
            eleve = Eleve.objects.get(user=user)
            return JsonResponse({'user_type': 'Élève','email': user.email,
        'image_profil': str(user.image_profil), 'details': eleve.to_json()}, status=200)
        elif user.is_admin:
            user_data = {
                'name': user.username,
                'email': user.email,
                'image_profil': str(user.image_profil),
                # Add other user fields as needed
            }
            return JsonResponse(user_data, status=200)
        else:
            return JsonResponse({'error': 'Type d\'utilisateur non valide'}, status=400)
    except User.DoesNotExist:
        return JsonResponse({'error': 'Utilisateur non trouvé'}, status=404)
    except (Parent.DoesNotExist, Professeur.DoesNotExist, Eleve.DoesNotExist):
        return JsonResponse({'error': 'Détails de l\'utilisateur non trouvés'}, status=404)
    user = User.objects.get(id=request.user.id)  # Assuming you have authentication in place

    # Return the user data as JSON response
    return JsonResponse(user_data)



def get_user_info(request, user_pk):
    try:
        user = User.objects.get(pk=user_pk)
        if user.is_parent:
            parent = Parent.objects.get(user=user)
            return JsonResponse({'user_type': 'Parent', 'details': parent.to_json()}, status=200)
        elif user.is_professeur:
            professeur = Professeur.objects.get(user=user)
            return JsonResponse({'user_type': 'Professeur', 'details': professeur.to_json()}, status=200)
        elif user.is_eleve:
            eleve = Eleve.objects.get(user=user)
            return JsonResponse({'user_type': 'Élève', 'details': eleve.to_json()}, status=200)
        else:
            return JsonResponse({'error': 'Type d\'utilisateur non valide'}, status=400)
    except User.DoesNotExist:
        return JsonResponse({'error': 'Utilisateur non trouvé'}, status=404)
    except (Parent.DoesNotExist, Professeur.DoesNotExist, Eleve.DoesNotExist):
        return JsonResponse({'error': 'Détails de l\'utilisateur non trouvés'}, status=404)
    





def obtenir_adresse_depuis_coordonnees(latitude, longitude):
    try:
        # Valider les coordonnées
        lat = float(latitude)
        lon = float(longitude)
        if not (-90 <= lat <= 90) or not (-180 <= lon <= 180):
            return "Latitude ou longitude hors limites."

        # URL pour le géocodage
        headers = {'User-Agent': 'ProfsChezVous'}
        url = f"https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat={latitude}&lon={longitude}&accept-language=fr"
        response = requests.get(url, headers=headers, timeout=10)


        if response.status_code == 200:
            data = response.json()
            adresse = data.get('address', {})
            
            # Extraction des composants de l'adresse et création d'une liste filtrée
            components = [
                adresse.get('road', ''),
                adresse.get('country', ''),
                adresse.get('city', ''),
                adresse.get('suburb', ''),
                adresse.get('state', '')
            ]
            # Filtrer les composants vides et joindre les restants avec une virgule
            concise_address = ', '.join(filter(None, components))

            return concise_address if concise_address else "Aucune adresse précise trouvée."
        else:
            return "Échec de la récupération de l'adresse."
    except Exception as e:
        return f"Erreur : {str(e)}"

    


from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse

@csrf_exempt
def ajouter_ou_modifier_photo_profil(request,user_pk):
    if request.method == 'POST':
        utilisateur = User.objects.get(pk=user_pk)
        image_profil = request.FILES.get('image_profil')

        if image_profil:
            # Mettre à jour le champ image_profil de l'utilisateur
            utilisateur.image_profil = image_profil
            utilisateur.save()

            return JsonResponse({'message': 'Photo de profil mise à jour avec succès.'})

    return JsonResponse({'error': 'Méthode de requête invalide.'}, status=405)



class EmailCheckAPIView(APIView):
    def get(self, request, email):
        # Vérifie si l'email existe dans la base de données
        try:
            user = User.objects.get(email=email)
            return Response({'email_existe': True}, status=status.HTTP_200_OK)
        except User.DoesNotExist:
            return Response({'email_existe': False}, status=status.HTTP_200_OK)



def get_professeur(request):
    Professeurs = Professeur.objects.all()
    Professeur_list = [
        Professeur.to_json()
        for Professeur in Professeurs
    ]
    return JsonResponse({'professeursDisponibles': Professeur_list})