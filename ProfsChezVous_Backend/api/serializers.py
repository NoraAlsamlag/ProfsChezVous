from rest_framework import serializers
from rest_framework import viewsets
from .models import CommentaireCours

from .models import Parent
from .models import Matiere
from .models import Professeur
from .models import CommentaireCours
from .models import Cours_Unite


class ParentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parent
        fields = '__all__'

        





class ProfesseurSerializer(serializers.ModelSerializer):
    class Meta:
        model = Professeur
        fields = '__all__'


class MatiereSerializer(serializers.ModelSerializer):
    class Meta:
        model = Matiere
        fields = '__all__'




class CommentaireCoursSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommentaireCours
        fields = '__all__'



class CommentaireCoursViewSet(viewsets.ModelViewSet):
    queryset = CommentaireCours.objects.all()
    serializer_class = CommentaireCoursSerializer


class VotreSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cours_Unite
        fields = '__all__'  # ou spécifiez les champs que vous souhaitez inclure dans votre sérialiseur



    

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