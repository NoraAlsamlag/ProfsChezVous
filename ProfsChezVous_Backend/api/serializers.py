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

from .models import      Cours , SuiviProfesseur , Disponibilite ,  CoursReserve

from .models import Absence, Remboursement, CoursRattrapage





class MatiereSerializer(serializers.ModelSerializer):
    class Meta:
        model = Matiere
        fields = '__all__'


class CommentaireCoursSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommentaireCours
        fields = '__all__'

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
        fields = '__all__' 

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

class CoursSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cours
        fields = '__all__'

class SuiviProfesseurSerializer(serializers.ModelSerializer):
    class Meta:
        model = SuiviProfesseur
        fields = '__all__' 

class DisponibiliteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Disponibilite
        fields = ['id', 'professeur', 'jour', 'heure_debut', 'heure_fin'] 

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