from rest_framework import serializers
from .models import CommentaireCours, Cours_Unite, Cours_Package, Matiere, DiscussionParentAdmin, DiscussionProfAdmin, Message, Activite, ActiviteBloquee

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

class DiscussionProfAdminSerializer(serializers.ModelSerializer):
    class Meta:
        model = DiscussionProfAdmin
        fields = '__all__'

class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = '__all__'

class ActiviteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Activite
        fields = '__all__'

class ActiviteBloqueeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActiviteBloquee
        fields = '__all__'
class CoursPackageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cours_Package
        fields = ['id', 'description', 'duree', 'date_debut', 'date_fin', 'est_actif', 'nombre_semaines', 'nombre_eleves', 'heures_par_semaine', 'matiere', 'prix']