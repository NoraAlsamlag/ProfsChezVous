from django.db import models
from django.contrib.auth.models import User

# Create your models here.




from django.db import models
from django.contrib.auth.models import User

class Parent(models.Model):
    nom = models.CharField(max_length=100)
    prenom = models.CharField(max_length=100)
    numero_telephone = models.CharField(max_length=20)
    adresse = models.CharField(max_length=200)
    cree_le = models.DateTimeField(auto_now_add=True)
    modifie_le = models.DateTimeField(auto_now=True)
    utilisateur = models.OneToOneField(User, on_delete=models.CASCADE, related_name='parent')

    def __str__(self):
        return f"{self.prenom} {self.nom}"

class Professeur(models.Model):
    nom = models.CharField(max_length=100)
    prenom = models.CharField(max_length=100)
    cree_le = models.DateTimeField(auto_now_add=True)
    modifie_le = models.DateTimeField(auto_now=True)
    utilisateur = models.OneToOneField(User, on_delete=models.CASCADE, related_name='professeur')

    def __str__(self):
        return f"{self.prenom} {self.nom}"

class Admin(models.Model):
    utilisateur = models.OneToOneField(User, on_delete=models.CASCADE, related_name='admin')

    def __str__(self):
        return f"Admin {self.utilisateur.username}"

class Matiere(models.Model):
    nom = models.CharField(max_length=100)
    description = models.TextField()
    professeurs = models.ManyToManyField(Professeur, related_name='matieres')

    def __str__(self):
        return self.nom

class CommentaireCours(models.Model):
    contenu = models.TextField()
    date = models.DateTimeField(auto_now_add=True)
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE, related_name='commentaires_professeur')
    parent = models.ForeignKey(Parent, on_delete=models.CASCADE, related_name='commentaires_parent')
    matiere = models.ForeignKey(Matiere, on_delete=models.CASCADE, related_name='commentaires')
    cours = models.ForeignKey('Cours', on_delete=models.CASCADE, related_name='commentaires')

    def __str__(self):
        return f"Commentaire de {self.professeur.utilisateur.username} pour {self.matiere.nom}"

class Cours(models.Model):
    nom = models.CharField(max_length=100)
    description = models.TextField()
    date_debut = models.DateTimeField()
    date_fin = models.DateTimeField()
    est_annule = models.BooleanField(default=False)
    matiere = models.ForeignKey(Matiere, on_delete=models.CASCADE, related_name='cours')
    professeur = models.ForeignKey(Professeur, on_delete=models.CASCADE, related_name='cours')

    def __str__(self):
        return self.nom

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