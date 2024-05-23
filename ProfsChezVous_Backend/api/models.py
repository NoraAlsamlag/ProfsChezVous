from django.db import models
from user.models import User,Professeur, Parent , Eleve
from django.utils import timezone
from rest_framework import serializers
from django.db import models
#from .models import Cours_Package
# Dans un fichier où vous avez besoin de Cours_Package
#from api.models import Cours_Package
timezone.now
import jsonfield


# models.py


class Categorie(models.Model):
    nom = models.CharField(max_length=150, help_text="Nom de la catégorie")

    def __str__(self):
        return self.nom

class Matiere(models.Model):
    nom_complet = models.CharField(max_length=150, help_text="Nom complet de la matière")
    symbole = models.CharField(max_length=50, help_text="Symbole de la matière")
    categorie = models.ForeignKey(Categorie, on_delete=models.CASCADE, related_name='matieres')

    # def to_json(self):
    #     return {
    #         'nom_complet': self.nom_complet,
    #         'symbole': self.symbole,
    #         'categorie': self.categorie.nom,
    #     }

    def __str__(self):
        return f"{self.nom_complet} - {self.symbole}"






class PrixDeBasePackage(models.Model):
    type = models.CharField(max_length=50, unique=True)
    prix_base = models.FloatField(default=100.0,null=True,blank=True)
    prix_par_heure = models.FloatField(default=100.0)
    prix_par_eleve = models.FloatField(default=50.0)

    def __str__(self):
        return self.type

class PrixDeBaseUnite(models.Model):
    type = models.CharField(default='unite',max_length=50, unique=True)
    prix_base = models.FloatField(default=100.0,null=True,blank=True)
    prix_par_heure = models.FloatField(default=100.0)
    prix_par_eleve = models.FloatField(default=50.0)

    def __str__(self):
        return self.type





class CommentaireCours(models.Model):
    contenu = models.TextField()
    date = models.DateTimeField(auto_now_add=True)
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE, related_name='commentaires_professeur')
    parent = models.ForeignKey(Parent, on_delete=models.CASCADE, related_name='commentaires_parent')
    matiere = models.ForeignKey(Matiere, on_delete=models.CASCADE, related_name='commentaires')
    Cours_Unite = models.BooleanField()
    Cours_Package = models.BooleanField()

    def __str__(self):
        return f"Commentaire de {self.professeur.nom} {self.professeur.prenom} pour {self.matiere.nom_complet}"


class Cours_Unite(models.Model):
    sujet = models.TextField(max_length=100,null=True,blank=True)
    date = models.DateField()
    heure_debut = models.TimeField(default='00:00', blank=False)
    STATUT_CHOICES = (
        ('R', 'Réservé'),
        ('C', 'Confirmé'),
        ('A', 'Annulé'),
    )
    prix = models.DecimalField(max_digits=10, decimal_places=2,null=True,blank=True)
    matiere = models.ForeignKey(Matiere, on_delete=models.PROTECT, null=False)
    professeur = models.ForeignKey(Professeur, on_delete=models.SET_NULL, null=True, blank=True, related_name='cours_unite') 
    parent = models.ForeignKey(Parent,on_delete=models.PROTECT, help_text="Parent",null=True,blank=True)
    statut = models.CharField(max_length=1, choices=STATUT_CHOICES, default='R')

    def calculer_end_time(self):
        heure_debut = self.heure_debut
        duree = self.duree
        heure_debut_datetime = timezone.datetime.combine(timezone.now().date(), heure_debut)
        heure_fine_datetime = heure_debut_datetime + timezone.timedelta(minutes=duree)
        heure_fine = heure_fine_datetime.time()
        return heure_fine

    @property
    def heure_fine(self):
        return self.calculer_end_time()

    def get_duration(self):
        """Return the duration of the course in HH:MM format."""
        hours, minutes = divmod(self.duree, 60)
        return f"{hours}:{minutes:02d}"

    def __str__(self):
        return f"{self.sujet}, le {self.date}, de {self.heure_debut} à {self.heure_fine}"



class Cours_Package(models.Model):
    description = models.TextField(null=True,blank=True)
    duree = models.PositiveIntegerField(help_text="Durée du forfait en jours")
    date_debut = models.DateField(help_text="Date de début de la validité du forfait")
    date_fin = models.DateField(help_text="Date de fin de la validité du forfait")
    est_actif = models.BooleanField(default=False, help_text="Le forfait est-il actuellement actif ?")
    SEMAINES_CHOICES = (
        (1, '1 semaine'),
        (2, '2 semaines'),
        (3, '3 semaines'),
        (4, '4 semaines'),
        (5, '5 semaines'),
        (6, '6 semaines'),
        (7, '7 semaines'),
        (8, '8 semaines'),
    )
    nombre_semaines = models.PositiveIntegerField(choices=SEMAINES_CHOICES, help_text="Nombre de semaines")
    nombre_eleves = models.PositiveIntegerField(choices=(
        (1, '1 élève'),
        (2, '2 élèves'),
        (3, '3 élèves'),
        (4, '4 élèves'),
        (5, '5 élèves'),
    ), help_text="Nombre d'élèves")
    heures_par_semaine = models.PositiveIntegerField(help_text="Nombre d'heures par semaine", default=0)
    matiere = models.ForeignKey('Matiere', on_delete=models.PROTECT, help_text="Matière du cours")
    prix = models.DecimalField(max_digits=10, decimal_places=2)
    selected_disponibilites = jsonfield.JSONField(help_text="Disponibilités sélectionnées" ,null=True,blank=True)
    professeur = models.ForeignKey(Professeur,on_delete=models.PROTECT, help_text="Professeur",null=True,blank=True)
    parent = models.ForeignKey(Parent,on_delete=models.PROTECT, help_text="Parent",null=True,blank=True)
    def __str__(self):
        return f"{self.description} ({self.duree} jours), Début: {self.date_debut}, Fin: {self.date_fin}"



    

    




class Message(models.Model):
    expediteur = models.ForeignKey(User, on_delete=models.CASCADE, related_name='messages_sent')
    destinataire = models.ForeignKey(User, on_delete=models.CASCADE, related_name='messages_received')
    contenu = models.TextField()
    date_envoi = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return f"Message : {self.contenu[:50]}..."



class Evaluation(models.Model):
    eleve = models.ForeignKey(Eleve, related_name='evaluations', on_delete=models.CASCADE)
    professeur = models.ForeignKey(Professeur, related_name='evaluations', on_delete=models.CASCADE)
    date = models.DateField()
    matiere = models.CharField(max_length=100)
    note = models.DecimalField(max_digits=5, decimal_places=2)

    def __str__(self):
        return f"Évaluation de {self.eleve} en {self.matiere} : {self.note}" 
    
class Transaction(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    parent = models.ForeignKey(Parent, on_delete=models.CASCADE)
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    percentage = models.DecimalField(max_digits=5, decimal_places=2)
    date_time = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=[('pending', 'Pending'), ('success', 'Success'), ('failed', 'Failed')])

    def __str__(self):
        return f"Transaction of {self.amount} by {self.user.username} at {self.date_time}" 






# import os

# def upload_to(instance, filename):
#     # Assurez-vous que le nom du fichier est unique
#     filename_base, filename_ext = os.path.splitext(filename)
#     return f'diplomes/{instance.professeur.user.username}/{filename_base}{filename_ext}'

# class Diplome(models.Model):
#     professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE)
#     fichier = models.FileField(upload_to=upload_to)

# def __str__(self):
#         return f"Diplôme de {self.professeur.user.username}"

class Cours(models.Model):
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE)
    eleve = models.ForeignKey(Eleve, on_delete=models.CASCADE)
    date = models.DateField()
    heure_debut = models.TimeField()
    heure_fin = models.TimeField()
    present = models.BooleanField(default=False)
    dispense = models.BooleanField(default=False)
    commentaire = models.TextField(blank=True, null=True)
    montant = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Cours de {self.professeur} avec {self.eleve} le {self.date}"
    
class SuiviProfesseur(models.Model):
    professeur = models.OneToOneField(Professeur, on_delete=models.CASCADE)
    cours_planifies = models.IntegerField(default=0)
    cours_effectues = models.IntegerField(default=0)
    cours_manques = models.IntegerField(default=0)

    def __str__(self):
        return f"Suivi de {self.professeur}" 




class CoursReserve(models.Model):
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE)
    eleve = models.ForeignKey(User, on_delete=models.CASCADE)
    date = models.DateField()
    heure_debut = models.TimeField()
    heure_fin = models.TimeField() 

class Absence(models.Model):
    eleve = models.ForeignKey(User, on_delete=models.CASCADE)
    date_absence = models.DateField()
    raison = models.TextField()

class Remboursement(models.Model):
    eleve = models.ForeignKey(User, on_delete=models.CASCADE)
    cours_manque = models.ForeignKey(Cours, on_delete=models.CASCADE)
    motif = models.TextField()
    montant_rembourse = models.DecimalField(max_digits=10, decimal_places=2)
    date_demande = models.DateField(auto_now_add=True)

class CoursRattrapage(models.Model):
    eleve = models.ForeignKey(User, on_delete=models.CASCADE)
    cours_manque = models.ForeignKey(Cours, on_delete=models.CASCADE)
    date_rattrapage = models.DateField()
    motif = models.TextField() 

    
class Notification(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    title = models.CharField(max_length=100)
    message = models.TextField()
    date = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)

    def to_json(self):
        return {
            'id': self.id,
            'title': self.title,
            'message': self.message,
            'date': self.date,
            'is_read': self.is_read
        }


    def __str__(self):
        return f"{self.title} - {self.message}"  # Modification de la méthode __str__



class Disponibilite(models.Model):
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE)
    date = models.CharField(max_length=20)  # Représente le jour de la semaine ("Lundi", "Mardi", etc.)
    heure = models.CharField(max_length=100)
    est_reserve = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.professeur} - {self.date} - {self.heure}"