from django.db import models
from django.contrib.auth.models import User
# from django.contrib.postgres.fields import ArrayField
# from django.contrib.gis.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django_resized import ResizedImageField

# Create your models here.


def upload_to(inst, nom_de_fichier ) :
    return "/profil/" + str(nom_de_fichier)

class User(AbstractUser):
    # Common fields for all user types
    image_profil = ResizedImageField(upload_to='upload_to', null=True, blank=True)
    cree_le = models.DateTimeField(auto_now_add=True)
    modifie_le = models.DateTimeField(auto_now=True)
    class Role(models.TextChoices) :
        ADMIN = "ADMIN",'Admin'
        PARENT = "PARENT",'Parent'
        ELEVE = "Eleve",'Eleve'
        PROFESSEUR = "PROFESSEUR" ,'Professeur'
    role_de_base = Role.ADMIN

    role = models.CharField(max_length=50,choices=Role.choices)
    

    
# class ParentManager(BaseUserManager) :
#     def get_queryset(self, *args, **kwargs):
#         results = super().get_queryset(*args **kwargs)
#         return results.filter( role=User.Role.PARENT)


class Parent(User):
    nom = models.CharField(max_length=100)
    prenom = models.CharField(max_length=100)
    ville = models.CharField(max_length=100)
    adresse = models.CharField(max_length=200)
    numero_telephone = models.CharField(max_length=12)
    # eleves = ArrayField(models.CharField(max_length=100), blank=True)
    quartier_résidence = models.CharField(max_length=70)
    # localisation = models.PointField(null=True, blank=True)
    role_de_base = User.Role.PARENT
    # parent = ParentManager()



    def __str__(self):
        return f"{self.nom} {self.prenom} (Parent)"

class Professeur(User):
    nom = models.CharField(max_length=100)
    prenom = models.CharField(max_length=100)
    ville = models.CharField(max_length=100)
    adresse = models.CharField(max_length=200)
    numero_telephone = models.CharField(max_length=12)
    role_de_base = User.Role.PROFESSEUR
    def __str__(self):
        return f"{self.prenom} {self.nom}"

class Eleve(User):
    nom = models.CharField(max_length=100)
    prenom = models.CharField(max_length=100)
    ville = models.CharField(max_length=100)
    adresse = models.CharField(max_length=200)
    numero_telephone = models.CharField(max_length=12)
    role_de_base =  User.Role.ELEVE

    def __str__(self):
        return f"{self.prenom} {self.nom}"
    
class Admin(User):
    role_de_base = User.Role.ADMIN

    def __str__(self):
        return f"Admin {User.nom}"
