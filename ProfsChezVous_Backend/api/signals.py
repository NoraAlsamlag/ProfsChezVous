from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Cours_Package, Notification

@receiver(post_save, sender=Cours_Package)
def envoyer_notification_reservation(sender, instance, created, **kwargs):
    if created:
        professeur = instance.professeur.user
        parent = instance.parent.user
        titre = "Nouvelle Réservation de Cours Forfait"
        message = f"Le parent {parent.prenom} {parent.nom} a réservé un cours forfait avec vous."
        Notification.objects.create(user=professeur, title=titre, message=message)
