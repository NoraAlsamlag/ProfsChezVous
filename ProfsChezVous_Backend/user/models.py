from django.db import models
# from api.models import Matiere
from django.contrib.auth.models import User
# from django.contrib.postgres.fields import ArrayField
# from django.contrib.gis.db import models, GeometryField
from django.conf import Settings
from django.dispatch import receiver
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django_resized import ResizedImageField
#from myapp.fields import ResizedImageField
from django import forms
#from .models.enfant import Enfant
from .forms import InscrireEnfantForm
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
    ville = models.CharField(max_length=100)
    adresse = models.CharField(max_length=200)
    prenom = models.CharField(max_length=30)
    nom = models.CharField(max_length=50)
    date_naissance = models.DateField()
    numero_telephone = models.CharField(max_length=12)
    # Eleve = models.ManyToManyField('Eleve')
    # eleves =ArrayField(models.CharField(max_length=100), blank=True)
    quartier_résidence = models.CharField(max_length=70)

    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
   
def inscrire_enfant(self, data):
    form = InscrireEnfantForm(data)
    if form.is_valid():
        enfant = Enfant(
            prenom=form.cleaned_data['prenom'],
            nom=form.cleaned_data['nom'],
            date_naissance=form.cleaned_data['date_naissance'],
            annee_scolaire=form.cleaned_data['annee_scolaire'],
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

class Professeur(models.Model):
    user  = models.OneToOneField(User , related_name='professeur',on_delete=models.CASCADE)
    ville = models.CharField(max_length=100)
    prenom = models.CharField(max_length=30)
    nom = models.CharField(max_length=50)
    adresse = models.CharField(max_length=200)
    quartier_résidence = models.CharField(max_length=70)
    numero_telephone = models.CharField(max_length=12)
    experience_enseignement = models.CharField(max_length=100)
    certifications = models.CharField(max_length=100)
    tarif_horaire = models.DecimalField(max_digits=10, decimal_places=2)
    date_naissance = models.DateField()
    # matiere_a_enseigner  = models.ManyToManyField(Matiere,related_name='matiere',on_delete=models.CASCADE)
    niveau_etude  = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.nom} {self.prenom} (Prof.)"


    

class Eleve(models.Model):
    user  = models.OneToOneField(User , related_name='eleve',on_delete=models.CASCADE)
    ville = models.CharField(max_length=100)
    adresse = models.CharField(max_length=200)
    prenom = models.CharField(max_length=30)
    nom = models.CharField(max_length=50)
    date_naissance = models.DateField()
    Etablissement = models.CharField(max_length=100) 
    niveau_scolaire = models.CharField(max_length=100)
   
    GENRE_CHOICES = (
        ('masculin', 'Masculin'),
        ('feminin', 'Féminin'),
        ('autre', 'Autre'),)
    genre = models.CharField(max_length=60, choices=GENRE_CHOICES)
    numero_telephone = models.CharField(max_length=12)

    

    def __str__(self):
        return f"{self.nom} {self.prenom}"

# class Absence(models.Model):
#     eleve = models.ForeignKey(Eleve, on_delete=models.CASCADE)
#     date = models.DateTimeField(default=datetime.now())





# class ClasseGeo(models.Model):
#     nom = models.CharField(max_length=100)
#     enseignant = models.ForeignKey(Professeur, on_delete=models.PROTECT)
#     lieu = GeometryField(srid=4326)

#     def __str__(self):
#         return self.nom

# class EleveGeo(models.Model):
#     eleve = models.OneToOneField(Eleve, parent_link=True, on_delete=models.CASCADE)
#     classegeo = models.ForeignKey(ClasseGeo, on_delete=models.PROTECT)


    def __str__(self):
        return f"{self.prenom} {self.nom}"
    
class Admin(models.Model):
    user  = models.OneToOneField(User , related_name='admin',on_delete=models.CASCADE)

    def __str__(self):
        return self.user.username



class InscrireEnfantForm(forms.Form):
    prenom = forms.CharField(max_length=30)
    nom = forms.CharField(max_length=50)
    date_naissance = forms.DateField()
    annee_scolaire = forms.CharField(max_length=100)
    etablissement = forms.CharField(max_length=100)

from django.db import models

class Enfant(models.Model):
    prenom = models.CharField(max_length=30)
    nom = models.CharField(max_length=50)
    date_naissance = models.DateField()
    annee_scolaire = models.CharField(max_length=100)
    etablissement = models.CharField(max_length=100)
    parent = models.ForeignKey('Parent', on_delete=models.CASCADE, related_name='enfants')

    def __str__(self):
        return f"{self.prenom} {self.nom}"

    class Meta:
        db_table = 'user_enfant'



