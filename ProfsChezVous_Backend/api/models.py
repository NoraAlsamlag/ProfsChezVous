from django.db import models
from user.models import User,Professeur,Parent
from django.utils import timezone

# Create your models here.

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
    Cours_Unite = models.ForeignKey('Cours_Unite', on_delete=models.CASCADE, related_name='commentaires' ,null=True)
    Cours_Package = models.ForeignKey('Cours_Package', on_delete=models.CASCADE, related_name='commentaires' ,null=True)

    def __str__(self):
        return f"Commentaire de {self.professeur.nom} {self.professeur.prenomnom} pour {self.matiere.nom_complet}"



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
        ('a_distance', 'Á distance'),
    )
    DURATION_CHOICES = (
        (60, '1 hour'),
        (120, '2 hours'),
        (180, '3 hours'),
        (240, '4 hours'),
    )
    duree = models.PositiveIntegerField(choices=DURATION_CHOICES)
    matière = models.ForeignKey(Matiere, on_delete=models.PROTECT,null=False)
    professeur = models.ForeignKey(Professeur, on_delete=models.SET_NULL, null=True, blank=True, related_name='cours_unite') 
    prix = models.DecimalField(max_digits=10, decimal_places=2)
    statut = models.CharField(max_length=1, choices=STATUT_CHOICES, default='R')
    lieu_des_cours = models.CharField(max_length=50, choices=lieu_des_cours_CHOICES)

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
    description = models.TextField()
    durée = models.PositiveIntegerField(help_text="Durée du forfait en jours")
    date_debut = models.DateField(help_text="Date de début de la validité du forfait")
    date_fin = models.DateField(help_text="Date de fin de la validité du forfait")
    est_actif = models.BooleanField(default=True, help_text="Le forfait est-il actuellement actif ?")
    STATUT_CHOICES = (
    ('P', 'Planifié'),
    ('E', 'En cours'),
    ('T', 'Terminé'),
    ('A', 'Annulé'),
)
    # Attributs supplémentaires pour les cours
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
    matiere = models.ForeignKey(Matiere, on_delete=models.PROTECT,null=False,help_text="Matière du cours")
    statut = models.CharField(max_length=1, choices=STATUT_CHOICES, default='P')
    prix = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.description} ({self.durée} jours), Début: {self.date_debut}, Fin: {self.date_fin}, Max Cours: {self.max_cours}, Max Utilisateurs: {self.max_utilisateurs}"


class Message(models.Model):
    expediteur = models.ForeignKey(User, related_name='messages_envoyes', on_delete=models.CASCADE)
    destinataire = models.ForeignKey(User, related_name='messages_recus', on_delete=models.CASCADE)
    contenu = models.TextField()
    date_envoi = models.DateTimeField(auto_now_add=True)
    lu = models.BooleanField(default=False)
    sujet = models.CharField(max_length=255)

    def __str__(self):
        return f"De : {self.expediteur}, À : {self.destinataire}, Sujet : {self.sujet}, Envoyé le : {self.date_envoi}"
