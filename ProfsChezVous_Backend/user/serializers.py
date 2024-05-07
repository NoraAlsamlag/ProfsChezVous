from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from django_resized import ResizedImageField
from rest_framework.validators import UniqueValidator
# from django.contrib.postgres.fields import ArrayField
from user.models import User,Parent, Professeur, Eleve, Admin
from .models import Parent,Enfant,cv_file_name,diplome_file_name
from django.core.files.uploadedfile import InMemoryUploadedFile
from io import BytesIO
#from .models import Transaction





class ParentRegisterSerializer(RegisterSerializer):
    # email = serializers.EmailField(
    #     required=True,
    #     validators=[UniqueValidator(queryset=User.objects.all())]
    # )
    nom = serializers.CharField(max_length=50)
    prenom = serializers.CharField(max_length=30)
    date_naissance = serializers.DateField()
    ville = serializers.CharField(max_length=100)
    # adresse = serializers.CharField(max_length=200)
    numero_telephone = serializers.CharField(max_length=12)
    # quartier_résidence = serializers.CharField(max_length=70)
    latitude = serializers.FloatField()
    longitude = serializers.FloatField()
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
            # 'adresse': self.validated_data.get('adresse'),
            'numero_telephone': self.validated_data.get('numero_telephone'),
            'latitude': self.validated_data.get('latitude'),
            'longitude': self.validated_data.get('longitude'),
        }
        Parent.objects.create(**parent_data)
        return user



class ProfesseurRegisterSerializer(RegisterSerializer):
    nom = serializers.CharField(max_length=50)
    prenom = serializers.CharField(max_length=30)
    ville = serializers.CharField(max_length=30)
    date_naissance = serializers.DateField()
    numero_telephone = serializers.CharField(max_length=12)
    cv = serializers.FileField(write_only=True, required=True, allow_empty_file=False, use_url=False)
    diplome = serializers.FileField(write_only=True, required=True, allow_empty_file=False, use_url=False)
    matiere_a_enseigner = serializers.CharField(max_length=100)
    niveau_etude = serializers.CharField(max_length=50)
    latitude = serializers.FloatField()
    longitude = serializers.FloatField()

    def to_internal_value(self, data):
        validated_data = super().to_internal_value(data)
        request = self.context.get('request')
        if 'cv' in data and isinstance(data['cv'], str):
            validated_data['cv'] = cv_file_name(request.user, data['cv'])
        if 'diplome' in data and isinstance(data['diplome'], str):
            validated_data['diplome'] = diplome_file_name(request.user, data['diplome'])
        return validated_data

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
            'numero_telephone': self.validated_data.get('numero_telephone'),
            'cv': self.validated_data.get('cv'),
            'diplome': self.validated_data.get('diplome'),
            'niveau_etude': self.validated_data.get('niveau_etude'),
            'matiere_a_enseigner': self.validated_data.get('matiere_a_enseigner'),
            'latitude': self.validated_data.get('latitude'),
            'longitude': self.validated_data.get('longitude'),
        }
        Professeur.objects.create(**professeur_data)
        return user

class EleveRegisterSerializer(RegisterSerializer):
    # email = serializers.EmailField(
    #     required=True,
    #     validators=[UniqueValidator(queryset=User.objects.all())]
    # )
    nom = serializers.CharField(max_length=50)
    prenom = serializers.CharField(max_length=30)
    ville = serializers.CharField(max_length=30)
    date_naissance = serializers.DateField()
    Etablissement = serializers.CharField(max_length=100)
    numero_telephone = serializers.CharField(max_length=12)
    niveau_scolaire = serializers.CharField(max_length=100)
    latitude = serializers.FloatField()
    longitude = serializers.FloatField()

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
            'date_naissance': self.validated_data.get('date_naissance'),
            'niveau_scolaire': self.validated_data.get('niveau_scolaire'),
            'numero_telephone': self.validated_data.get('numero_telephone'),
            'Etablissement': self.validated_data.get('Etablissement'),
            'latitude': self.validated_data.get('latitude'),
            'longitude': self.validated_data.get('longitude'),
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

