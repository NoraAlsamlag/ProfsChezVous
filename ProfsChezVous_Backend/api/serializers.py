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
