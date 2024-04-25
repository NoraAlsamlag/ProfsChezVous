from rest_framework import serializers
from .models import Matiere
from .models import CommentaireCours
from .models import Cours_Unite 
from .models import Cours_Package
#from .serializers import CoursPackageSerializer
from .models import DiscussionParentAdmin




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

class DiscussionParentAdminSerializer(serializers.ModelSerializer):
    class Meta:
        model = DiscussionParentAdmin
        fields = '__all__'