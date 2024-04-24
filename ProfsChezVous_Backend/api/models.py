from django.db import models
from user.models import User, Admin, Professeur, Parent
from django.utils import timezone
from rest_framework import serializers

from rest_framework import viewsets


class Matiere(models.Model):
    nom_complet = models.CharField(max_length=150, help_text="Nom complet de la matière")
    symbole = models.CharField(max_length=50, help_text="Symbole de la matière")

    def __str__(self):
        return f"{self.nom_complet} - {self.symbole}"

class CommentaireCours(models.Model):
    contenu = models.TextField()
    date = models.DateTimeField(auto_now_add=True)
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE, related_name='commentaires_professeur')
    parent = models.ForeignKey(Parent, on_delete=models.CASCADE, related_name='commentaires_parent')
    matiere = models.ForeignKey(Matiere, on_delete=models.CASCADE, related_name='commentaires')
    Cours_Unite = models.ForeignKey('Cours_Unite', on_delete=models.CASCADE, related_name='commentaires', null=True)
    Cours_Package = models.ForeignKey('Cours_Package', on_delete=models.CASCADE, related_name='commentaires', null=True)

    def __str__(self):
        return f"Commentaire de {self.professeur.nom} {self.professeur.prenom} pour {self.matiere.nom_complet}"

class Cours_Unite(models.Model):
    sujet = models.TextField(max_length=100)
    date = models.DateField()
    heure_debut = models.TimeField(default='00:00', blank=False)
    STATUT_CHOICES = (
        ('R', 'Réservé'),
        ('C', 'Confirmé'),
        ('A', 'Annulé'),
    )
    lieu_des_cours_CHOICES = (
        ('la_maison', 'La maison'),
        ('a_distance', 'À distance'),
    )
    DURATION_CHOICES = (
        (60, '1 hour'),
        (120, '2 hours'),
        (180, '3 hours'),
        (240, '4 hours'),
    )
    duree = models.PositiveIntegerField(choices=DURATION_CHOICES)
    matiere = models.ForeignKey(Matiere, on_delete=models.PROTECT, null=False)
    professeur = models.ForeignKey(Professeur, on_delete=models.SET_NULL, null=True, blank=True, related_name='cours_unite') 
    statut = models.CharField(max_length=1, choices=STATUT_CHOICES, default='R')
    lieu_des_cours = models.CharField(max_length=50, choices=lieu_des_cours_CHOICES)

    def calculate_end_time(self):
        heure_debut = self.heure_debut
        duree = self.duree
        heure_debut_datetime = timezone.datetime.combine(timezone.now().date(), heure_debut)
        heure_fine_datetime = heure_debut_datetime + timezone.timedelta(minutes=duree)
        heure_fine = heure_fine_datetime.time()
        return heure_fine

    @property
    def heure_fine(self):
        return self.calculate_end_time()

    def get_duration(self):
        """Return the duration of the course in HH:MM format."""
        hours, minutes = divmod(self.duree, 60)
        return f"{hours}:{minutes:02d}"

    def __str__(self):
        return f"{self.sujet}, le {self.date}, de {self.heure_debut} à {self.heure_fine}"

class Cours_Package(models.Model):
    description = models.TextField()
    duree = models.PositiveIntegerField(help_text="Durée du forfait en jours")
    date_debut = models.DateField(help_text="Date de début de la validité du forfait")
    date_fin = models.DateField(help_text="Date de fin de la validité du forfait")
    est_actif = models.BooleanField(default=True, help_text="Le forfait est-il actuellement actif ?")
    
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
    heures_par_semaine = models.CharField(max_length=10, choices=(
        ('2h', '2 heures'),
        ('4h', '4 heures'),
        ('6h', '6 heures'),
        ('8h', '8 heures'),
        ('10h', '10 heures'),
        ('12h', '12 heures'),
        ('14h', '14 heures'),
    ), help_text="Nombre d'heures par semaine")
    matiere = models.ForeignKey(Matiere, on_delete=models.PROTECT, null=False, help_text="Matière du cours")
    prix = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.description} ({self.duree} jours), Début: {self.date_debut}, Fin: {self.date_fin}"

class DiscussionParentAdmin(models.Model):
    sujet = models.CharField(max_length=200)
    date_creation = models.DateTimeField(auto_now_add=True)
    derniere_activite = models.DateTimeField(auto_now=True)
    parent = models.ForeignKey(Parent, on_delete=models.CASCADE, related_name='discussions_avec_admin')
    admin = models.ForeignKey(Admin, on_delete=models.CASCADE, related_name='discussions_avec_parent')
    messages = models.ManyToManyField('Message', related_name='messages_parent_admin')

    def __str__(self):
        return self.sujet

class DiscussionProfAdmin(models.Model):
    sujet = models.CharField(max_length=200)
    date_creation = models.DateTimeField(auto_now_add=True)
    derniere_activite = models.DateTimeField(auto_now=True)
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE, related_name='discussions_avec_admin')
    admin = models.ForeignKey(Admin, on_delete=models.CASCADE, related_name='discussions_avec_prof')
    messages = models.ManyToManyField('Message', related_name='messages_prof_admin')

    def __str__(self):
        return self.sujet

class Message(models.Model):
    contenu = models.TextField()
    date_envoi = models.DateTimeField(auto_now_add=True)
    discussion_parent_admin = models.ForeignKey('DiscussionParentAdmin', on_delete=models.CASCADE, related_name='parent_discussion')
    discussion_prof_admin = models.ForeignKey('DiscussionProfAdmin', on_delete=models.CASCADE, related_name='prof_discussion')

    def __str__(self):
        return f"Message : {self.contenu[:50]}..."

class Activite(models.Model):
    nom = models.CharField(max_length=100)
    description = models.TextField(max_length=200)
    date_debut = models.DateField()
    date_fin = models.DateField()
    lieu = models.CharField(max_length=200)
    participants = models.ManyToManyField(User, related_name='activites')

    def __str__(self):
        return self.nom
    
class ActiviteBloquee(models.Model):
    activite = models.ForeignKey('Activite', on_delete=models.CASCADE)
    raison = models.CharField(max_length=200)
    date_debut = models.DateField()
    date_fin = models.DateField()

    def __str__(self):
        return f"{self.activite} - {self.raison}"
