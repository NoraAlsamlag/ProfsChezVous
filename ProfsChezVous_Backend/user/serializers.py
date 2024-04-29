from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from django_resized import ResizedImageField
# from django.contrib.postgres.fields import ArrayField
from user.models import Parent, Professeur, Eleve, Admin


from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from .models import Parent
from .models import Enfant
from rest_framework import serializers

from django.core.files.uploadedfile import InMemoryUploadedFile
from io import BytesIO
from rest_framework import serializers
#from .models import Transaction





class ParentRegisterSerializer(RegisterSerializer):
    nom = serializers.CharField(max_length=50)
    prenom = serializers.CharField(max_length=30)
    date_naissance = serializers.DateField()
    ville = serializers.CharField(max_length=100)
    adresse = serializers.CharField(max_length=200)
    numero_telephone = serializers.CharField(max_length=12)
    quartier_résidence = serializers.CharField(max_length=70)
    # eleves = ArrayField(serializers.CharField(max_length=100), blank=True)
    

    def get_cleaned_data(self):
        cleaned_data = super().get_cleaned_data()
        cleaned_data['is_parent'] = True
        # Récupérer l'image de la requête correctement
        image_profil = self.context["request"].FILES.get('image_profil')
        if image_profil:
            cleaned_data['image_profil'] = image_profil
        return cleaned_data

    def save(self, request):
        user = super().save(request)
        user.is_parent = True
        # Enregistrer l'image dans l'instance de l'utilisateur
        image_profil = self.validated_data.get('image_profil')
        if image_profil:
            user.image_profil = image_profil
            user.save()
        parent_data = {
            'user': user,
            'nom': self.validated_data.get('nom'),
            'prenom': self.validated_data.get('prenom'),
            'ville': self.validated_data.get('ville'),
            'date_naissance': self.validated_data.get('date_naissance'),
            'adresse': self.validated_data.get('adresse'),
            'numero_telephone': self.validated_data.get('numero_telephone'),
            'quartier_résidence': self.validated_data.get('quartier_résidence'),
        }
        Parent.objects.create(**parent_data)
        return user

class ProfesseurRegisterSerializer(RegisterSerializer):
    nom = serializers.CharField(max_length=50)
    prenom = serializers.CharField(max_length=30)
    ville = serializers.CharField(max_length=30)
    date_naissance = serializers.DateField()
    adresse = serializers.CharField(max_length=30)
    numero_telephone = serializers.CharField(max_length=12)
    experience_enseignement = serializers.CharField(max_length=100)
    certifications = serializers.CharField(max_length=100)
    tarif_horaire = serializers.DecimalField(max_digits=10, decimal_places=2)

    def get_cleaned_data(self):
        cleaned_data = super().get_cleaned_data()
        cleaned_data['is_professeur'] = True
        return cleaned_data

    def save(self, request):
        user = super().save(request)
        user.is_professeur = True
        user.save()
        professeur_data = {
            'user': user,
            'nom': self.validated_data.get('nom'),
            'prenom': self.validated_data.get('prenom'),
            'ville': self.validated_data.get('ville'),
            'date_naissance': self.validated_data.get('date_naissance'),
            'adresse': self.validated_data.get('adresse'),
            'numero_telephone': self.validated_data.get('numero_telephone'),
        }
        Professeur.objects.create(**professeur_data)
        return user

class EleveRegisterSerializer(RegisterSerializer):
    nom = serializers.CharField(max_length=50)
    prenom = serializers.CharField(max_length=30)
    ville = serializers.CharField(max_length=30)
    adresse = serializers.CharField(max_length=30)
    date_naissance = serializers.DateField()
    Etablissement = serializers.CharField(max_length=100) 
    GENRE_CHOICES = (
        ('masculin', 'Masculin'),
        ('feminin', 'Féminin'),
        ('autre', 'Autre'),)
    genre = serializers.ChoiceField( choices=GENRE_CHOICES)
    numero_telephone = serializers.CharField(max_length=12)

    def get_cleaned_data(self):
        cleaned_data = super().get_cleaned_data()
        cleaned_data['is_eleve'] = True
        return cleaned_data

    def save(self, request):
        user = super().save(request)
        user.is_eleve = True
        user.save()
        eleve_data = {
            'user': user,
            'nom': self.validated_data.get('nom'),
            'prenom': self.validated_data.get('prenom'),
            'ville': self.validated_data.get('ville'),
            'adresse': self.validated_data.get('adresse'),
            'date_naissance': self.validated_data.get('date_naissance'),
            'genre': self.validated_data.get('genre'),
            'numero_telephone': self.validated_data.get('numero_telephone'),
            'Etablissement': self.validated_data.get('Etablissement'),
        }
        Eleve.objects.create(**eleve_data)
        return user

class AdminRegisterSerializer(RegisterSerializer):

    def get_cleaned_data(self):
        cleaned_data = super().get_cleaned_data()
        cleaned_data['is_admin'] = True
        return cleaned_data

    def save(self, request):
        user = super().save(request)
        user.is_admin = True
        user.save()
        admin_data = {
            'user': user,
        }
        Admin.objects.create(**admin_data)
        return user

from rest_framework import serializers
from .models import User

from rest_framework import serializers

class UserSerializer(serializers.ModelSerializer):
    image_profil = serializers.ImageField()  # Add image_profil field
    is_admin = serializers.BooleanField()  # Add is_admin field

    class Meta:
        model = User
        fields = ['pk', 'username', 'email', 'first_name', 'last_name', 'image_profil', 'is_admin']  # Define the default display fields
        read_only_fields = ['pk', 'email']  # Define the read-only fields


class ParentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parent
        fields = ['id','user', 'nom', 'prenom', 'date_naissance', 'ville', 'adresse', 'numero_telephone', 'quartier_résidence']


class EleveSerializer(serializers.ModelSerializer):
    class Meta:
        model = Eleve
        fields = ['id', 'user', 'ville', 'adresse', 'prenom', 'nom', 'date_naissance', 'Etablissement', 'niveau_scolaire', 'genre', 'numero_telephone']

class ProfesseurSerializer(serializers.ModelSerializer):
    class Meta:
        model = Professeur
        fields = ['id', 'user', 'ville', 'prenom', 'nom', 'adresse', 'quartier_résidence', 'numero_telephone', 'experience_enseignement', 'certifications', 'tarif_horaire', 'date_naissance', 'niveau_etude']

class CustomLoginSerializer(LoginSerializer):
    pass

class EnfantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Enfant
        fields = '__all__'

       

        



#class TransactionSerializer(serializers.ModelSerializer):
  #  class Meta:
    #    model = Transaction
      #  fields = '__all__'
# serializers.py

