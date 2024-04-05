from rest_framework import serializers
from rest_framework import viewsets
from .models import CommentaireCours

from .models import Parent
from .models import Matiere
from .models import Professeur
from .models import CommentaireCours

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