from rest_framework import generics, permissions
from rest_framework import viewsets
from .models import *
from .serializers import *
from .signals import envoyer_notification_confirmation
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from django.core.mail import send_mail
from rest_framework import status
from django.views.decorators.http import require_http_methods
import json
from django.shortcuts import render, get_object_or_404, redirect
from django.conf import settings
from django.urls import reverse
import logging
import locale
from datetime import datetime, timedelta
from rest_framework.response import Response
from django.shortcuts import render
from django.contrib.contenttypes.models import ContentType
import uuid
from django.contrib.auth.decorators import login_required
# from django.shortcuts import redirect


logger = logging.getLogger(__name__)

# S'assurer que les noms des jours sont en français
locale.setlocale(locale.LC_TIME, 'fr_FR')

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



class VueCoursPackageReservesUtilisateur(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, *args, **kwargs):
        try:
            utilisateur = request.user
        except utilisateur.DoesNotExist:
            return Response({"detail": "Utilisateur non trouvé."}, status=404)

        cours_package = Cours_Package.objects.filter(user_id=utilisateur.id).order_by('date', 'heure_debut')

        serializeur_package = CoursPackageSerializer(cours_package, many=True)

        return Response({
            'cours_package': serializeur_package.data
        })

class VueCoursUniteReservesUtilisateur(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, *args, **kwargs):
        try:
            utilisateur = request.user
        except utilisateur.DoesNotExist:
            return Response({"detail": "Utilisateur non trouvé."}, status=404)

        cours_unite = Cours_Unite.objects.filter(user_id=utilisateur.id)

        serializeur_unite = CoursUniteSerializer(cours_unite, many=True)

        return Response({
            'cours_unite': serializeur_unite.data
        })


class CoursPackageNonConfirmesView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        utilisateur = self.request.user
        professeur = Professeur.objects.get(user_id=utilisateur.id)
        return Cours_Package.objects.filter(professeur=professeur, statut='R')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = CoursPackageSerializer(queryset, many=True)
        return Response(serializer.data)





class CoursUniteNonConfirmesView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        utilisateur = self.request.user
        professeur = Professeur.objects.get(user_id=utilisateur.id)
        return Cours_Unite.objects.filter(professeur=professeur, statut='R')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = CoursUniteSerializer(queryset, many=True)
        return Response(serializer.data)


from django.conf import settings
from django.urls import reverse
from rest_framework import generics, permissions
from rest_framework.response import Response
from .models import Cours_Unite, Cours_Package, Notification, Parent
from .serializers import CoursUniteSerializer, CoursPackageSerializer

class ConfirmerCoursUniteView(generics.UpdateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Cours_Unite.objects.all()
    serializer_class = CoursUniteSerializer

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        instance.statut = 'C'
        instance.save()

        # Générer le lien de paiement
        lien_paiement = f'{settings.SITE_URL}{reverse("payer", args=["unite", instance.id])}'

        # Envoyer une notification après la confirmation du cours
        envoyer_notification_confirmation(instance.professeur, instance.user.id, instance.sujet, lien_paiement)

        serializer = self.get_serializer(instance)
        return Response(serializer.data)

class ConfirmerCoursPackageView(generics.UpdateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Cours_Package.objects.all()
    serializer_class = CoursPackageSerializer

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        instance.est_actif = True
        instance.save()

        # Générer le lien de paiement
        lien_paiement = f'{settings.SITE_URL}{reverse("payer", args=["package", instance.id])}'

        # Envoyer une notification après la confirmation du cours
        envoyer_notification_confirmation(instance.professeur, instance.user.id, instance.description, lien_paiement)

        serializer = self.get_serializer(instance)
        return Response(serializer.data)






class TousLesCoursView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        utilisateur = request.user
        queryset = Cour.objects.filter(user=utilisateur, statut__in=['AV', 'EC']).order_by('date', 'heure_debut')
        serializer = CourSerializer(queryset, many=True, context={'request': request})
        return JsonResponse(serializer.data, safe=False, json_dumps_params={'ensure_ascii': False})


class CoursAVenirView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        utilisateur = request.user
        queryset = Cour.objects.filter(user=utilisateur, statut='AV').order_by('date', 'heure_debut')
        serializer = CourSerializer(queryset, many=True, context={'request': request})
        return JsonResponse(serializer.data, safe=False, json_dumps_params={'ensure_ascii': False})


class CoursTerminesOuAnnullesView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        utilisateur = request.user
        queryset = Cour.objects.filter(user=utilisateur, statut__in=['T', 'A']).order_by('date', 'heure_debut')
        serializer = CourSerializer(queryset, many=True, context={'request': request})
        return JsonResponse(serializer.data, safe=False, json_dumps_params={'ensure_ascii': False})

class ProfesseurTousLesCoursView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        utilisateur = request.user
        professeur = Professeur.objects.get(user=utilisateur)
        queryset = Cour.objects.filter(professeur=professeur, statut__in=['AV', 'EC']).order_by('date', 'heure_debut')
        serializer = CourSerializer(queryset, many=True, context={'request': request})
        return JsonResponse(serializer.data, safe=False, json_dumps_params={'ensure_ascii': False})


class ProfesseurCoursAVenirView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        utilisateur = request.user
        professeur = Professeur.objects.get(user=utilisateur)
        queryset = Cour.objects.filter(professeur=professeur, statut='AV').order_by('date', 'heure_debut')
        serializer = CourSerializer(queryset, many=True, context={'request': request})
        return JsonResponse(serializer.data, safe=False, json_dumps_params={'ensure_ascii': False})


class ProfesseurCoursTerminesOuAnnullesView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        utilisateur = request.user
        professeur = Professeur.objects.get(user=utilisateur)
        queryset = Cour.objects.filter(professeur=professeur, statut__in=['T', 'A']).order_by('date', 'heure_debut')
        serializer = CourSerializer(queryset, many=True, context={'request': request})
        return JsonResponse(serializer.data, safe=False, json_dumps_params={'ensure_ascii': False})



class EnvoyerMessageAdminView(generics.CreateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = MessageSerializer

    def perform_create(self, serializer):
        admin = User.objects.filter(is_superuser=True).first()
        if admin:
            serializer.save(expediteur=self.request.user, destinataire=admin)
        else:
            raise serializers.ValidationError("Administrateur non trouvé")


class ListeMessagesAvecAdminView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = MessageSerializer

    def get_queryset(self):
        user = self.request.user
        admin = User.objects.filter(is_superuser=True).first()
        if admin:
            return Message.objects.filter(expediteur=user, destinataire=admin) | Message.objects.filter(expediteur=admin, destinataire=user)
        return Message.objects.none()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return JsonResponse(serializer.data, safe=False, json_dumps_params={'ensure_ascii': False})

class MettreAJourPresenceView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = CourSerializer
    queryset = Cour.objects.all()

    def patch(self, request, *args, **kwargs):
        cours = self.get_object()
        cours.present = request.data.get('present', cours.present)
        cours.save()
        return Response({'status': 'Présence mise à jour'}, status=status.HTTP_200_OK)

class MettreAJourStatutView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = CourSerializer
    queryset = Cour.objects.all()

    def patch(self, request, *args, **kwargs):
        cours = self.get_object()
        statut = request.data.get('statut')
        if statut:
            cours.statut = statut
            cours.save()
            return Response({'status': 'Statut mis à jour'}, status=status.HTTP_200_OK)
        return Response({'error': 'Statut non fourni'}, status=status.HTTP_400_BAD_REQUEST)

class MettreAJourDispenseView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = CourSerializer
    queryset = Cour.objects.all()

    def patch(self, request, *args, **kwargs):
        cours = self.get_object()
        cours.dispense = request.data.get('dispense', cours.dispense)
        cours.save()
        return Response({'status': 'Dispense mise à jour'}, status=status.HTTP_200_OK)


class AjouterCommentaireView(generics.CreateAPIView):
    serializer_class = CommentaireCoursSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        user = request.user
        cour_id = request.data.get('cour')
        if not cour_id:
            return JsonResponse({"detail": "Le champ 'cour' est requis."}, status=status.HTTP_400_BAD_REQUEST)

        if CommentaireCours.objects.filter(user=user, cour_id=cour_id).exists():
            return JsonResponse({"detail": "Vous avez déjà laissé un commentaire pour ce cours."}, status=status.HTTP_400_BAD_REQUEST)

        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=user)
            return JsonResponse(serializer.data, status=status.HTTP_201_CREATED)
        return JsonResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MessageViewSet(viewsets.ModelViewSet):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer 

class TransactionListView(generics.ListCreateAPIView):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer
    permission_classes = [IsAuthenticated]

class TransactionDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer 


class EvaluationListAPIView(generics.ListCreateAPIView):
    queryset = Evaluation.objects.all()
    serializer_class = EvaluationSerializer

class EvaluationRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Evaluation.objects.all()
    serializer_class = EvaluationSerializer


class CoursListCreateAPIView(generics.ListCreateAPIView):
    queryset = Cour.objects.all()
    serializer_class = CourSerializer

class CoursRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Cour.objects.all()
    serializer_class = CourSerializer

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








@csrf_exempt
@require_http_methods(["POST"])
def calculer_prix_cours_unite(request):
    try:
        logger.debug("Request body: %s", request.body)
        data = json.loads(request.body)
        matiere_id = data.get('matiere')
        nombre_eleves = data.get('nombre_eleves')

        if matiere_id is None or nombre_eleves is None:
            logger.error("Données manquantes: matiere_id=%s, nombre_eleves=%s", matiere_id, nombre_eleves)
            return JsonResponse({'error': 'Données manquantes'}, status=400)

        try:
            matiere = Matiere.objects.get(id=matiere_id)
        except Matiere.DoesNotExist:
            logger.error("Matière non trouvée: %s", matiere_id)
            return JsonResponse({'error': 'Matière non trouvée'}, status=404)

        try:
            prix_de_base = PrixDeBaseUnite.objects.get(type="unite")
        except PrixDeBaseUnite.DoesNotExist:
            logger.error("Prix de base non trouvé")
            return JsonResponse({'error': 'Prix de base non trouvé'}, status=404)

        prix = prix_de_base.prix_base + matiere.prix + (prix_de_base.prix_par_eleve * nombre_eleves)
        logger.debug("Calculated price: %s", prix)
        return JsonResponse({'prix': prix}, status=200)

    except json.JSONDecodeError as e:
        logger.exception("JSON decode error")
        return JsonResponse({'error': 'Requête invalide'}, status=400)
    except Exception as e:
        logger.exception("An error occurred")
        return JsonResponse({'error': str(e)}, status=500)






def obtenir_categories_et_matieres(request):
    categories = Categorie.objects.all()
    data = {categorie.nom: list(categorie.matieres.values('id', 'nom_complet', 'symbole')) for categorie in categories}
    return JsonResponse(data, safe=False)

@login_required
def deja_paye_page(request):
    return render(request, 'deja_paye.html')






@login_required
def payment_page(request, cours_id, cours_type):
    if cours_type == 'unite':
        cours = get_object_or_404(Cours_Unite, id=cours_id)
    elif cours_type == 'package':
        cours = get_object_or_404(Cours_Package, id=cours_id)
    else:
        return JsonResponse({'erreur': 'Type de cours invalide'}, status=400)

    # Vérifier si le paiement a déjà été effectué
    transaction_exists = Transaction.objects.filter(
        user=request.user,
        content_type=ContentType.objects.get_for_model(cours),
        object_id=cours_id,
        statut='success'
    ).exists()

    if transaction_exists:
        return redirect('deja_paye_page')

    auth_token = request.user.auth_token.key  # Assuming you are using token authentication

    return render(request, 'payment.html', {'cours': cours, 'cours_type': cours_type, 'auth_token': auth_token})





@csrf_exempt
@login_required
def fake_payment(request):
    if request.method == 'POST':
        if not request.user.is_authenticated:
            return JsonResponse({'erreur': 'Utilisateur non authentifié'}, status=400)
        
        try:
            data = json.loads(request.body)
            print("Data received:", data)  # Journaliser les données reçues

            montant = data['montant']
            professeur_id = data['professeur_id']
            user = request.user  # Utiliser l'utilisateur authentifié
            professeur = User.objects.get(id=professeur_id)
            cours_type = data['cours_type']  # 'unite' ou 'package'
            cours_id = data['cours_id']

            # Générer un identifiant unique et professionnel pour la transaction
            now = datetime.now()
            unique_id = uuid.uuid4().hex[:6].upper()
            id_transaction = f'TXN-{now.strftime("%Y%m%d%H%M%S")}-{unique_id}'
            statut = 'success'  # Le paiement est réussi

            # Calculer la répartition du montant
            pourcentage_admin = 0.05  # Exemple : 5% pour l'admin
            montant_admin = montant * pourcentage_admin
            montant_prof = montant - montant_admin

            # Obtenir le contenu de l'objet cours (unité ou package)
            if cours_type == 'unite':
                content_type = ContentType.objects.get_for_model(Cours_Unite)
                cours = Cours_Unite.objects.get(id=cours_id)
                cours.statut = 'C'
                cours.et_payer = True
                cours.save()

                # Création d'un objet Cour avec les données de Cours_Unite
                Cour.objects.create(
                    professeur=cours.professeur,
                    user=cours.user,
                    date=cours.date,
                    heure_debut=cours.heure_debut,
                    heure_fin=cours.heure_fine,
                    statut='AV',
                    commentaire=f"Cours confirmé à partir de Cours_Unite: {cours.sujet}"
                )
            elif cours_type == 'package':
                content_type = ContentType.objects.get_for_model(Cours_Package)
                cours = Cours_Package.objects.get(id=cours_id)
                cours.est_actif = True
                cours.et_payer = True
                cours.save()
                
                # Parse les disponibilités sélectionnées
                try:
                    disponibilites = json.loads(cours.selected_disponibilites)
                except json.JSONDecodeError as e:
                    return JsonResponse({"error": "Format de disponibilités sélectionnées invalide"}, status=400)

                # Créer des cours pour chaque jour de la semaine dans la plage de dates
                current_date = cours.date_debut
                end_date = cours.date_fin

                while current_date <= end_date:
                    # Obtenir le nom du jour en français
                    day_name_fr = current_date.strftime('%A')
                    
                    if day_name_fr in disponibilites:
                        for time_range in disponibilites[day_name_fr]:
                            start_time_str, end_time_str = time_range.split(' - ')
                            start_time = datetime.strptime(start_time_str, '%H:%M').time()
                            end_time = datetime.strptime(end_time_str, '%H:%M').time()

                            try:
                                Cour.objects.create(
                                    professeur=cours.professeur,
                                    user=cours.user,
                                    date=current_date,
                                    heure_debut=start_time,
                                    heure_fin=end_time,
                                    statut='AV',
                                    commentaire=f"Cours de {cours.matiere.symbole} pour le package {cours.description}"
                                )
                            except Exception as e:
                                return JsonResponse({"erreur": str(e)}, status=400)
                    current_date += timedelta(days=1)

            else:
                return JsonResponse({'erreur': 'Type de cours invalide'}, status=400)

            # Enregistrer la transaction dans la base de données
            transaction = Transaction.objects.create(
                user=user,
                professeur=professeur,
                montant=montant,
                id_transaction=id_transaction,
                montant_prof=montant_prof,
                montant_admin=montant_admin,
                statut=statut,
                content_type=content_type,
                object_id=cours.id,
            )

            return JsonResponse({'message': 'Paiement réussi', 'id_transaction': id_transaction})
        except Exception as e:
            print("Error:", e)  # Journaliser l'erreur
            return JsonResponse({'erreur': str(e)}, status=400)








def success_page(request):
    return render(request, 'success.html')

def cancel_page(request):
    return render(request, 'cancel.html')
