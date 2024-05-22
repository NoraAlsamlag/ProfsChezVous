from rest_framework import generics , permissions
from rest_framework import viewsets
from .models import *
from .serializers import *
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from django.core.mail import send_mail
from rest_framework import status
from django.views.decorators.http import require_http_methods
from .serializers import NotificationUpdateSerializer
import json
from django.contrib.auth.models import User

class MatiereList(generics.ListCreateAPIView):
    queryset = Matiere.objects.all()
    serializer_class = MatiereSerializer


class MatieresProfesseurView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = MatiereSerializer

    def get_queryset(self):
        professeur_id = self.kwargs['professeur_id']
        try:
            professeur = Professeur.objects.get(id=professeur_id)
            return professeur.matieres_a_enseigner.all()
        except Professeur.DoesNotExist:
            return Response({'erreur': 'Professeur non trouvé'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'erreur': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class MatiereDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Matiere.objects.all()
    serializer_class = MatiereSerializer

class CommentaireCoursList(generics.ListCreateAPIView):
    queryset = CommentaireCours.objects.all()
    serializer_class = CommentaireCoursSerializer

class CommentaireCoursDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = CommentaireCours.objects.all()
    serializer_class = CommentaireCoursSerializer

class CoursUniteViewSet(viewsets.ModelViewSet):
    queryset = Cours_Unite.objects.all()
    serializer_class = CoursUniteSerializer

class CoursPackageViewSet(viewsets.ModelViewSet):
    queryset = Cours_Package.objects.all()
    serializer_class = CoursPackageSerializer



class VueCoursReservesUtilisateur(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, *args, **kwargs):
        utilisateur = request.user
        try:
            parent = Parent.objects.get(user_id=utilisateur.id)
        except Parent.DoesNotExist:
            return Response({"detail": "Parent non trouvé."}, status=404)

        cours_package = Cours_Package.objects.filter(parent_id=parent.id)

        serializeur_package = CoursPackageSerializer(cours_package, many=True)

        return Response({
            'cours_package': serializeur_package.data
        })




class CoursPackageNonConfirmesView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        utilisateur = self.request.user
        professeur = Professeur.objects.get(user_id=utilisateur.id)
        return Cours_Package.objects.filter(professeur=professeur, est_actif=False)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = CoursPackageSerializer(queryset, many=True)
        return Response(serializer.data)

class ConfirmerCoursPackageView(generics.UpdateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Cours_Package.objects.all()
    serializer_class = CoursPackageSerializer

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        instance.est_actif = True
        instance.save()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)


class MessageViewSet(viewsets.ModelViewSet):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer 

class TransactionListView(generics.ListCreateAPIView):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer

class TransactionDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer 


class EvaluationListAPIView(generics.ListCreateAPIView):
    queryset = Evaluation.objects.all()
    serializer_class = EvaluationSerializer

class EvaluationRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Evaluation.objects.all()
    serializer_class = EvaluationSerializer


# class DiplomeListCreateAPIView(generics.ListCreateAPIView):
#     queryset = Diplome.objects.all()
#     serializer_class = DiplomeSerializer
#     permission_classes = [IsAuthenticated]

#     def perform_create(self, serializer):
#         serializer.save(professeur=self.request.user.professeur)

# class DiplomeRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
#     queryset = Diplome.objects.all()
#     serializer_class = DiplomeSerializer
#     permission_classes = [IsAuthenticated]

class CoursListCreateAPIView(generics.ListCreateAPIView):
    queryset = Cours.objects.all()
    serializer_class = CoursSerializer

class CoursRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Cours.objects.all()
    serializer_class = CoursSerializer

class SuiviProfesseurRetrieveUpdateAPIView(generics.RetrieveUpdateAPIView):
    queryset = SuiviProfesseur.objects.all()
    serializer_class = SuiviProfesseurSerializer 


class SuiviProfesseurListAPIView(generics.ListAPIView):
    serializer_class = SuiviProfesseurSerializer 


class CoursReserveListCreateAPIView(generics.ListCreateAPIView):
    queryset = CoursReserve.objects.all()
    serializer_class = CoursReserveSerializer

class CoursReserveRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CoursReserve.objects.all()
    serializer_class = CoursReserveSerializer 

@api_view(['POST'])
def reserver_cours(request):
    serializer = CoursReserveSerializer(data=request.data)
    if serializer.is_valid():
        # Vérification de la disponibilité du professeur
        professeur = serializer.validated_data['professeur']
        date_cours = serializer.validated_data['date']
        heure_debut = serializer.validated_data['heure_debut']
        heure_fin = serializer.validated_data['heure_fin']

        disponibilites = Disponibilite.objects.filter(professeur=professeur, jour=date_cours, heure_debut__lte=heure_debut, heure_fin__gte=heure_fin)
        if not disponibilites.exists():
            return JsonResponse({'error': 'Le professeur n\'est pas disponible à ce moment-là'}, status=status.HTTP_400_BAD_REQUEST)

        # Enregistrement du cours réservé
        serializer.save()

        # Envoi de notification au professeur
        sujet = "Nouveau cours réservé"
        message = f"Un nouveau cours a été réservé pour vous le {date_cours} de {heure_debut} à {heure_fin}."
        send_mail(sujet, message, 'votre@email.com', [professeur.user.email])

        return JsonResponse(serializer.data, status=status.HTTP_201_CREATED)
    return JsonResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 

class AbsenceListCreateAPIView(generics.ListCreateAPIView):
    queryset = Absence.objects.all()
    serializer_class = AbsenceSerializer
    permission_classes = [IsAuthenticated]

class AbsenceRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Absence.objects.all()
    serializer_class = AbsenceSerializer
    permission_classes = [IsAuthenticated]

class RemboursementListCreateAPIView(generics.ListCreateAPIView):
    queryset = Remboursement.objects.all()
    serializer_class = RemboursementSerializer
    permission_classes = [IsAuthenticated]

class RemboursementRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Remboursement.objects.all()
    serializer_class = RemboursementSerializer
    permission_classes = [IsAuthenticated]

class CoursRattrapageListCreateAPIView(generics.ListCreateAPIView):
    queryset = CoursRattrapage.objects.all()
    serializer_class = CoursRattrapageSerializer
    permission_classes = [IsAuthenticated]

class CoursRattrapageRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CoursRattrapage.objects.all()
    serializer_class = CoursRattrapageSerializer
    permission_classes = [IsAuthenticated] 

def signaler_absence(request):
    # Traitement de la demande d'absence
    # Création de l'instance Absence
    # Envoi de notifications aux professeurs concernés
    return JsonResponse({'message': 'Absence signalée avec succès'})

def demander_remboursement(request):
    # Traitement de la demande de remboursement
    # Création de l'instance Remboursement
    # Vérification de l'éligibilité au remboursement
    return JsonResponse({'message': 'Demande de remboursement soumise avec succès'})

def planifier_rattrapage(request):
    # Traitement de la planification du cours de rattrapage
    # Création de l'instance CoursRattrapage
    return JsonResponse({'message': 'Cours de rattrapage planifié avec succès'}) 





class NotificationListCreateAPIView(generics.ListCreateAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer

class NotificationRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer





@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def obtenir_notifications(request):
    if request.user.is_authenticated:
        # Récupère toutes les notifications associées à l'utilisateur connecté
        notifications = Notification.objects.filter(user=request.user)
        # Convertit chaque notification en format JSON en utilisant la méthode to_json définie dans le modèle
        liste_notifications = [notification.to_json() for notification in notifications]
        # Retourne la liste des notifications en format JSON
        return JsonResponse({'NotificationsDisponibles': liste_notifications})
    else:
        # Retourne une erreur si l'utilisateur n'est pas authentifié
        return JsonResponse({'error': 'Utilisateur non authentifié'}, status=401)


@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_notification_status(request, notification_id):
    try:
        notification = Notification.objects.get(id=notification_id, user=request.user)
    except Notification.DoesNotExist:
        return JsonResponse({'error': 'Notification not found'}, status=404)

    serializer = NotificationUpdateSerializer(notification, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({'message': 'Notification status updated successfully'}, status=status.HTTP_200_OK)
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def nombre_notifications_non_lues(request):
    nombre_non_lues = Notification.objects.filter(user=request.user, is_read=False).count()
    return JsonResponse({'nombre_non_lues': nombre_non_lues})




@csrf_exempt
@require_http_methods(["POST"])
def ajouter_disponibilite(request):
    data = json.loads(request.body)
    professeur = Professeur.objects.get(id=data['professeur_id'])
    date = data['date']
    heure = data['heure']
    disponibilite = Disponibilite(professeur=professeur, date=date, heure=heure)
    disponibilite.save()
    return JsonResponse({'status': 'success'})

@csrf_exempt
@require_http_methods(["GET"])
def obtenir_disponibilites(request, professeur_id):
    disponibilites = Disponibilite.objects.filter(professeur__id=professeur_id)
    disponibilites_dict = {}
    for dispo in disponibilites:
        date_str = dispo.date
        if date_str not in disponibilites_dict:
            disponibilites_dict[date_str] = []
        disponibilites_dict[date_str].append(dispo.heure)
    return JsonResponse(disponibilites_dict, safe=False)

@csrf_exempt
@require_http_methods(["POST"])
def reserver_disponibilite(request):
    data = json.loads(request.body)
    disponibilite = Disponibilite.objects.get(professeur__id=data['professeur_id'], date=data['date'], heure=data['heure'])
    disponibilite.est_reserve = True
    disponibilite.save()
    return JsonResponse({'status': 'success'})


@csrf_exempt
def supprimer_disponibilite(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            professeur_id = data.get('professeur_id')
            date = data.get('date')
            heure = data.get('heure')

            if not professeur_id or not date or not heure:
                return JsonResponse({'error': 'Données manquantes'}, status=400)

            disponibilite = Disponibilite.objects.filter(
                professeur_id=professeur_id,
                date=date,
                heure=heure
            ).first()

            if disponibilite:
                disponibilite.delete()
                return JsonResponse({'message': 'Disponibilité supprimée'}, status=200)
            else:
                return JsonResponse({'error': 'Disponibilité non trouvée'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Méthode de requête invalide'}, status=405)


@csrf_exempt
@require_http_methods(["DELETE"])
def annuler_cours_package(request, cours_id):
    try:
        cours = Cours_Package.objects.get(id=cours_id)
        disponibilites = json.loads(cours.selected_disponibilites)

        for jour, heures in disponibilites.items():
            for heure in heures:
                disponibilite, created = Disponibilite.objects.get_or_create(
                    professeur=cours.professeur,
                    date=jour,
                    heure=heure
                )
                disponibilite.est_reserve = False
                disponibilite.save()

        cours.delete()
        return JsonResponse({'status': 'success'})
    except Cours_Package.DoesNotExist:
        return JsonResponse({'error': 'Cours forfait non trouvé'}, status=404)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)





@csrf_exempt
@require_http_methods(["POST"])
def calculer_prix_cours_package(request):
    try:
        data = json.loads(request.body)
        nombre_semaines = data.get('nombre_semaines')
        heures_par_semaine = data.get('heures_par_semaine')
        nombre_eleves = data.get('nombre_eleves')

        if nombre_semaines is None or nombre_eleves is None or heures_par_semaine is None:
            return JsonResponse({'error': 'Données manquantes'}, status=400)

        try:
            prix_de_base = PrixDeBasePackage.objects.get(type="package")
        except PrixDeBasePackage.DoesNotExist:
            return JsonResponse({'error': 'Prix de base non trouvé'}, status=404)

        prix = nombre_semaines * (prix_de_base.prix_base + (prix_de_base.prix_par_heure * heures_par_semaine) + (prix_de_base.prix_par_eleve * nombre_eleves))
        return JsonResponse({'prix': prix}, status=200)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)






def obtenir_categories_et_matieres(request):
    categories = Categorie.objects.all()
    data = {categorie.nom: list(categorie.matieres.values('id', 'nom_complet', 'symbole')) for categorie in categories}
    return JsonResponse(data, safe=False)


from http import HTTPStatus
from django.http import Http404
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAuthenticatedOrReadOnly


from user.serializers import *


try:

    from home.models import Parent

except:
    pass

class ParentView(APIView):

    permission_classes = (IsAuthenticatedOrReadOnly,)

    def post(self, request):
        serializer = ParentSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(data={
                **serializer.errors,
                'success': False
            }, status=HTTPStatus.BAD_REQUEST)
        serializer.save()
        return Response(data={
            'message': 'Record Created.',
            'success': True
        }, status=HTTPStatus.OK)

    def get(self, request, pk=None):
        if not pk:
            return Response({
                'data': [ParentSerializer(instance=obj).data for obj in Parent.objects.all()],
                'success': True
            }, status=HTTPStatus.OK)
        try:
            obj = get_object_or_404(Parent, pk=pk)
        except Http404:
            return Response(data={
                'message': 'object with given id not found.',
                'success': False
            }, status=HTTPStatus.NOT_FOUND)
        return Response({
            'data': ParentSerializer(instance=obj).data,
            'success': True
        }, status=HTTPStatus.OK)

    def put(self, request, pk):
        try:
            obj = get_object_or_404(Parent, pk=pk)
        except Http404:
            return Response(data={
                'message': 'object with given id not found.',
                'success': False
            }, status=HTTPStatus.NOT_FOUND)
        serializer = ParentSerializer(instance=obj, data=request.data, partial=True)
        if not serializer.is_valid():
            return Response(data={
                **serializer.errors,
                'success': False
            }, status=HTTPStatus.BAD_REQUEST)
        serializer.save()
        return Response(data={
            'message': 'Record Updated.',
            'success': True
        }, status=HTTPStatus.OK)

    def delete(self, request, pk):
        try:
            obj = get_object_or_404(Parent, pk=pk)
        except Http404:
            return Response(data={
                'message': 'object with given id not found.',
                'success': False
            }, status=HTTPStatus.NOT_FOUND)
        obj.delete()
        return Response(data={
            'message': 'Record Deleted.',
            'success': True
        }, status=HTTPStatus.OK)

