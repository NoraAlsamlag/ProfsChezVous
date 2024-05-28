from rest_framework import serializers
from .models import Matiere
from .models import CommentaireCours
from .models import Cours_Unite 
from .models import Cours_Package

#from .serializers import CoursPackageSerializer
#from .models import DiscussionParentAdmin
from .models import Message

from .models import Transaction
from rest_framework import serializers
from .models import Evaluation

#from .models import Diplome

from .models import      Cour , SuiviProfesseur , Disponibilite ,  CoursReserve

from .models import Absence, Remboursement, CoursRattrapage
from rest_framework import serializers
from .models import Notification




class MatiereSerializer(serializers.ModelSerializer):
    class Meta:
        model = Matiere
        fields = '__all__'



class CommentaireCoursSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommentaireCours
        fields = '__all__'

    # def validate(self, data):
    #     request = self.context.get('request')
    #     user = request.user if request else None
    #     cour = data.get('cour')

    #     if not cour:
    #         raise serializers.ValidationError({"cour": "Le champ 'cour' est requis."})

    #     if CommentaireCours.objects.filter(user=user, cour=cour).exists():
    #         raise serializers.ValidationError("Vous avez déjà laissé un commentaire pour ce cours.")

    #     return data
    
    


class CoursUniteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cours_Unite
        fields = '__all__' 

class CoursPackageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cours_Package
        fields = '__all__' 

#class DiscussionParentAdminSerializer(serializers.ModelSerializer):
    #class Meta:
        #model = DiscussionParentAdmin
        #fields = '__all__'  

class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = ['id', 'expediteur', 'destinataire', 'contenu', 'date_envoi']
        read_only_fields = ['id', 'expediteur', 'date_envoi']

class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = '__all__' 



class EvaluationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Evaluation
        fields = '__all__' 

# class DiplomeSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Diplome
#         fields = '__all__' 



from datetime import datetime
from django.utils import timezone
import locale

locale.setlocale(locale.LC_TIME, "fr_FR.utf8")

class CourSerializer(serializers.ModelSerializer):
    professeur_nom_complet = serializers.SerializerMethodField()
    commentaire_user = serializers.SerializerMethodField()
    class Meta:
        model = Cour
        fields = '__all__'

    def get_professeur_nom_complet(self, obj):
        return f"{obj.professeur.prenom} {obj.professeur.nom}"
    
    def get_commentaire_user(self, obj):
        user = self.context['request'].user
        commentaire = CommentaireCours.objects.filter(cour=obj, user=user).first()
        return commentaire.contenu if commentaire else None

class SuiviProfesseurSerializer(serializers.ModelSerializer):
    class Meta:
        model = SuiviProfesseur
        fields = '__all__'  

class CoursReserveSerializer(serializers.ModelSerializer):
    class Meta:
        model = CoursReserve
        fields = ['id', 'professeur', 'eleve', 'date', 'heure_debut', 'heure_fin'] 

class AbsenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Absence
        fields = '__all__'

class RemboursementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Remboursement
        fields = '__all__'

class CoursRattrapageSerializer(serializers.ModelSerializer):
    class Meta:
        model = CoursRattrapage
        fields = '__all__' 



class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = '__all__'



class NotificationUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['is_read']
        extra_kwargs = {
            'is_read': {'required': True}
        }
