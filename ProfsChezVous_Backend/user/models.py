from django.db import models
# from api.models import Matiere
from django.contrib.auth.models import User
# from django.contrib.postgres.fields import ArrayField
# from django.contrib.gis.db import models, GeometryField

from django.conf import Settings
from django.dispatch import receiver
from django.db.models.signals import post_save
from rest_framework.authtoken.models import Token

from django.contrib.auth.models import AbstractUser, BaseUserManager
from django_resized import ResizedImageField


# Create your models here.


def upload_to(inst, nom_de_fichier ) :
    return "/profil/" + str(nom_de_fichier)

class User(AbstractUser):
    # Common fields for all user types
    is_admin  = models.BooleanField(default=False)
    is_parent  = models.BooleanField(default=False)
    is_eleve  = models.BooleanField(default=False)
    is_professeur  = models.BooleanField(default=False)
    image_profil = ResizedImageField(upload_to=upload_to, null=True, blank=True)
    cree_le = models.DateTimeField(auto_now_add=True)
    modifie_le = models.DateTimeField(auto_now=True)
    
    def  __str__(self):
        return  self.username
    
# class ParentManager(BaseUserManager) :
#     def get_queryset(self, *args, **kwargs):
#         results = super().get_queryset(*args **kwargs)
#         return results.filter( role=User.Role.PARENT)


class Parent(models.Model):
    user  = models.OneToOneField(User , related_name='parent',on_delete=models.CASCADE)
    ville = models.CharField(max_length=100)
    adresse = models.CharField(max_length=200)
    prenom = models.CharField(max_length=30)
    nom = models.CharField(max_length=50)
    numero_telephone = models.CharField(max_length=12)
    # eleves =models.Model ArrayField(models.CharField(max_length=100), blank=True)
    quartier_résidence = models.CharField(max_length=70)
    # localisation = models.PointField(null=True, blank=True)
    # parent = ParentManager()



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
    date_naissance = models.DateField()
    # matiere_a_enseigner  = models.ManyToManyField(Matiere,related_name='matiere',on_delete=models.CASCADE)
    niveau_etude  = models.CharField(max_length=50)


    # specialite = models.ForeignKey('Specialites', on_delete=models.SET_NULL, null=True, blank=True)

    def __str__(self):
        return f"{self.nom} {self.prenom} (Prof.)"


    

class Eleve(models.Model):
    user  = models.OneToOneField(User , related_name='eleve',on_delete=models.CASCADE)
    ville = models.CharField(max_length=100)
    adresse = models.CharField(max_length=200)
    prenom = models.CharField(max_length=30)
    nom = models.CharField(max_length=50)
    date_naissance = models.DateField()
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
