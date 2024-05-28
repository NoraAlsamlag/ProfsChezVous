from django.db.models.signals import post_save
from django.db.models.signals import post_delete
from django.dispatch import receiver
from .models import Cours_Package, Notification
from user.models import  Parent

@receiver(post_save, sender=Cours_Package)
def envoyer_notification_reservation(sender, instance, created, **kwargs):
    if created:
        professeur = instance.professeur.user
        user = instance.user
        titre = "Nouvelle Réservation de Cours Forfait"
        message = f"{user.first_name} {user.last_name} a réservé un cours forfait avec vous."
        Notification.objects.create(user=professeur, title=titre, message=message)



def envoyer_notification_annulation(professeur, parent_id, cours_description):
    try:
        parent = Parent.objects.get(id=parent_id)
        notification = Notification(
            user=parent.user,
            title='Cours Annulé',
            message=f'Le professeur {professeur.nom} {professeur.prenom} a annulé le cours: {cours_description}.',
        )
        notification.save()
    except Parent.DoesNotExist:
        print(f'Parent with id {parent_id} does not exist')
    except Exception as e:
        print(f'Error sending notification: {e}')

@receiver(post_delete, sender=Cours_Package)
def cours_package_post_delete(sender, instance, **kwargs):
    professeur = instance.professeur
    parent_id = instance.parent.id
    cours_description = instance.description
    envoyer_notification_annulation(professeur, parent_id, cours_description)
