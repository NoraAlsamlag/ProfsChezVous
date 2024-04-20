from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from user.models import Parent, Professeur, Eleve, Admin


from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from .models import Parent, User

class ParentRegisterSerializer(RegisterSerializer):
    nom = serializers.CharField(max_length=50)
    prenom = serializers.CharField(max_length=30)
    ville = serializers.CharField(max_length=100)
    adresse = serializers.CharField(max_length=200)
    numero_telephone = serializers.CharField(max_length=12)
    quartier_résidence = serializers.CharField(max_length=70)

    def get_cleaned_data(self):
        cleaned_data = super().get_cleaned_data()
        cleaned_data['is_parent'] = True
        return cleaned_data

    def save(self, request):
        user = super().save(request)
        user.is_parent = True
        user.save()
        parent_data = {
            'user': user,
            'ville': self.validated_data.get('ville'),
            'adresse': self.validated_data.get('adresse'),
            'numero_telephone': self.validated_data.get('numero_telephone'),
            'ville': self.validated_data.get('ville'),
            'adresse': self.validated_data.get('adresse'),
            'quartier_résidence': self.validated_data.get('quartier_résidence'),
        }
        Parent.objects.create(**parent_data)
        return user
class ProfesseurRegisterSerializer(RegisterSerializer):
    nom = serializers.CharField(max_length=50)
    prenom = serializers.CharField(max_length=30)
    ville = serializers.CharField(max_length=30)
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

class CustomLoginSerializer(LoginSerializer):
    pass