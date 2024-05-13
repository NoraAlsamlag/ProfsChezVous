from django.db import models
from django.contrib.auth.models import User
# from django.contrib.postgres.fields import ArrayField
# from django.contrib.gis.db import models, GeometryField
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django_resized import ResizedImageField
from django import forms
from .forms import InscrireEnfantForm

#from .utils.forms import InscrireEnfantForm

#from .models import Transaction

#from user.models import Parent, Professeur


# Create your models here.


import os

def upload_to(inst, nom_de_fichier):
    # Assurez-vous que nom_de_fichier est un nom de fichier sécurisé
    filename = f"{inst.pk}_{nom_de_fichier}"
    # Joignez le nom de fichier sécurisé avec le répertoire 'profil'
    return os.path.join('profil', filename)



class User(AbstractUser):
    is_admin  = models.BooleanField(default=False)
    is_parent  = models.BooleanField(default=False)
    is_eleve  = models.BooleanField(default=False)
    is_professeur  = models.BooleanField(default=False)
    image_profil = ResizedImageField(upload_to=upload_to, null=True, blank=True)
    cree_le = models.DateTimeField(auto_now_add=True)
    modifie_le = models.DateTimeField(auto_now=True)
    
    def  __str__(self):
        return  self.email
    


class Parent(models.Model):
    user  = models.OneToOneField(User , related_name='parent',on_delete=models.CASCADE)
    nom = models.CharField(max_length=50)
    prenom = models.CharField(max_length=30)
    ville = models.CharField(max_length=100)
    date_naissance = models.DateField()
    numero_telephone = models.CharField(max_length=12)
    latitude = models.FloatField()
    longitude = models.FloatField()
    
    def to_json(self):
        from .views import obtenir_adresse_depuis_coordonnees
        adresse = obtenir_adresse_depuis_coordonnees(self.latitude, self.longitude)
        return {
            'user_id': self.user.id,
            'ville': self.ville,
            'prenom': self.prenom,
            'nom': self.nom,
            'date_naissance': self.date_naissance.strftime('%Y-%m-%d'),
            'numero_telephone': self.numero_telephone,
            'adresse': adresse,
            'latitude': self.latitude,
            'longitude': self.longitude,
        }

    def inscrire_enfant(self, data):
        form = InscrireEnfantForm(data)
        if form.is_valid():
            enfant = Enfant(
                prenom=form.cleaned_data['prenom'],
                nom=form.cleaned_data['nom'],
                date_naissance=form.cleaned_data['date_naissance'],
                niveau_scolaire=form.cleaned_data['niveau_scolaire'],
                etablissement=form.cleaned_data['etablissement'],
                parent=self
            )
            enfant.save()
            return enfant
        else:
            raise ValueError("Formulaire invalide")
    



    # localisation = models.PointField(null=True, blank=True)



    def __str__(self):
        return f"{self.nom} {self.prenom} (Parent)"



def diplome_file_name(inst, filename):
    ext = filename.split('.')[-1]
    file_name = f"{inst.user.pk}_{inst.prenom}_diplome.{ext}"
    return os.path.join("diplome",file_name)

def cv_file_name(inst, filename):
    # Generate the file name using ID, first name, and "cv"
    ext = filename.split('.')[-1]
    file_name = f"{inst.user.pk}_{inst.prenom}_cv.{ext}"
    return os.path.join('cv', file_name)

class Professeur(models.Model):
    user  = models.OneToOneField(User , related_name='professeur',on_delete=models.CASCADE)
    nom = models.CharField(max_length=50)
    prenom = models.CharField(max_length=30)
    ville = models.CharField(max_length=100)
    # adresse = models.CharField(max_length=200)
    # quartier_résidence = models.CharField(max_length=70)
    numero_telephone = models.CharField(max_length=12)
    cv = models.FileField(upload_to=cv_file_name)
    diplome = models.FileField(upload_to=diplome_file_name)
    # tarif_horaire = models.CharField(max_length=50)
    date_naissance = models.DateField()
    matiere_a_enseigner  = models.CharField(max_length=100)
    niveau_etude  = models.CharField(max_length=50)
    latitude = models.FloatField()
    longitude = models.FloatField()

    def to_json(self):
        from .views import obtenir_adresse_depuis_coordonnees
        adresse = obtenir_adresse_depuis_coordonnees(self.latitude, self.longitude)
        
        return {
            'user_id': self.user.id,
            'ville': self.ville,
            'prenom': self.prenom,
            'nom': self.nom,
            'numero_telephone': self.numero_telephone,
            'cv': str(self.cv) if self.cv else None,
            'diplome': str(self.diplome) if self.diplome else None,
            'niveau_etude': self.niveau_etude,
            'matiere_a_enseigner': self.matiere_a_enseigner,
            'image_profil': str(self.user.image_profil.url) if self.user.image_profil else None,
            'date_naissance': self.date_naissance.strftime('%Y-%m-%d'),
            'adresse': adresse,
            'latitude': self.latitude,
            'longitude': self.longitude,
        }



    def __str__(self):
        return f"{self.nom} {self.prenom} (Prof.)"


    

class Eleve(models.Model):
    user  = models.OneToOneField(User , related_name='eleve',on_delete=models.CASCADE)
    nom = models.CharField(max_length=50)

    prenom = models.CharField(max_length=30)
    ville = models.CharField(max_length=100)
    date_naissance = models.DateField()
    Etablissement = models.CharField(max_length=100) 
    niveau_scolaire = models.CharField(max_length=100)
    numero_telephone = models.CharField(max_length=12)
    latitude = models.FloatField()
    longitude = models.FloatField()

    def to_json(self):
        from .views import obtenir_adresse_depuis_coordonnees
        adresse = obtenir_adresse_depuis_coordonnees(self.latitude, self.longitude)
        return {
            'user_id': self.user.id,
            'ville': self.ville,
            'prenom': self.prenom,
            'nom': self.nom,
            'date_naissance': self.date_naissance.strftime('%Y-%m-%d'),
            'etablissement': self.Etablissement,
            'niveau_scolaire': self.niveau_scolaire,
            'numero_telephone': self.numero_telephone,
            'adresse': adresse,
            'latitude': self.latitude,
            'longitude': self.longitude,
        }

    def __str__(self):
        return f"{self.nom} {self.prenom}"
    
class Admin(models.Model):
    user  = models.OneToOneField(User , related_name='admin',on_delete=models.CASCADE)

    def __str__(self):
        return self.user.username



class InscrireEnfantForm(forms.Form):
    prenom = forms.CharField(max_length=30)
    nom = forms.CharField(max_length=50)
    date_naissance = forms.DateField()
    niveau_scolaire = forms.CharField(max_length=100)
    etablissement = forms.CharField(max_length=100)

from django.db import models

class Enfant(models.Model):
    prenom = models.CharField(max_length=30)
    nom = models.CharField(max_length=50)
    date_naissance = models.DateField()
    niveau_scolaire = models.CharField(max_length=100)
    etablissement = models.CharField(max_length=100)
    parent = models.ForeignKey('Parent', on_delete=models.CASCADE, related_name='enfants')

    def __str__(self):
        return f"{self.prenom} {self.nom}"




