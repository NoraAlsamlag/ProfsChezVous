from rest_framework import generics , permissions
from rest_framework import viewsets
#from .models import DiscussionParentAdmin
#from .serializers import DiscussionParentAdminSerializer
from .models import Transaction ,Evaluation,Message,CommentaireCours,Matiere,Cours_Package,Cours_Unite , Disponibilite , CoursReserve
from .serializers import *
#from .serializers import DiplomeSerializer


from rest_framework.permissions import IsAuthenticated
from .serializers import CoursSerializer, SuiviProfesseurSerializer 

from .serializers import DisponibiliteSerializer 
from django.core.mail import send_mail
from .serializers import CoursReserveSerializer 
from django.http import JsonResponse
from rest_framework import status
from rest_framework.decorators import api_view
from .models import CoursReserve, Disponibilite
from .serializers import CoursReserveSerializer
from rest_framework.permissions import IsAuthenticated
from .models import Absence, Remboursement, CoursRattrapage
from .serializers import AbsenceSerializer, RemboursementSerializer, CoursRattrapageSerializer




class MatiereList(generics.ListCreateAPIView):
    queryset = Matiere.objects.all()
    serializer_class = MatiereSerializer

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

class DisponibiliteListCreateAPIView(generics.ListCreateAPIView):
    queryset = Disponibilite.objects.all()
    serializer_class = DisponibiliteSerializer

class DisponibiliteRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Disponibilite.objects.all()
    serializer_class = DisponibiliteSerializer 

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
    # Vérification de la disponibilité des professeurs
    return JsonResponse({'message': 'Cours de rattrapage planifié avec succès'})