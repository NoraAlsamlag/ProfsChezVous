from django.db.models.signals import post_save
from django.db.models.signals import post_delete
from django.dispatch import receiver
from .models import Cours_Package, Notification,Cours_Unite
from user.models import  Parent,User

@receiver(post_save, sender=Cours_Package)
def envoyer_notification_reservation_package(sender, instance, created, **kwargs):
    if created:
        professeur = instance.professeur.user
        user = instance.user
        titre = "Nouvelle Réservation de Cours Forfait"
        message = f"{user.first_name} {user.last_name} a réservé un cours forfait avec vous."
        Notification.objects.create(user=professeur, title=titre, message=message)

@receiver(post_save, sender=Cours_Unite)
def envoyer_notification_reservation_unite(sender, instance, created, **kwargs):
    if created:
        professeur = instance.professeur.user
        user = instance.user
        titre = "Nouvelle Réservation de Cours Unité"
        message = f"{user.first_name} {user.last_name} a réservé un cours unité avec vous."
        Notification.objects.create(user=professeur, title=titre, message=message)




def envoyer_notification_annulation(professeur, user_id, cours_description):
    try:
        user = User.objects.get(id=user_id)
        notification = Notification(
            user=user,
            title='Cours Annulé',
            message=f'Le professeur {professeur.nom} {professeur.prenom} a annulé le cours: {cours_description}.',
        )
        notification.save()
    except Parent.DoesNotExist:
        print(f'L\'utilisateure avec l\'id {user_id} n\'existe pas')
    except Exception as e:
        print(f'Erreur lors de l\'envoi de la notification: {e}')


def envoyer_notification_confirmation(professeur, user_id, cours_description, lien_paiement):
    try:
        user = User.objects.get(id=user_id)
        notification = Notification(
            user=user,
            title='Cours Confirmé',
            message=f'Le professeur {professeur.nom} {professeur.prenom} a confirmé le cours: {cours_description}. Veuillez effectuer le paiement en suivant ce lien : {lien_paiement}',
        )
        notification.save()
    except Parent.DoesNotExist:
        print(f'L\'utilisateure avec l\'id {user_id} n\'existe pas')
    except Exception as e:
        print(f'Erreur lors de l\'envoi de la notification: {e}')

# def envoyer_payment_notification(user, cours):
#     subject = 'Confirmation de votre cours'
#     message = f'Votre cours {cours} a été confirmé. Veuillez effectuer le paiement en suivant ce lien : {settings.SITE_URL}{reverse("payer", args=[cours.id])}'
#     email_from = settings.EMAIL_HOST_USER
#     recipient_list = [user.email]
#     send_mail(subject, message, email_from, recipient_list)

# @receiver(post_delete, sender=Cours_Package)
# def cours_package_post_delete(sender, instance, **kwargs):
#     professeur = instance.professeur
#     parent_id = instance.parent.id
#     cours_description = instance.description
#     envoyer_notification_annulation(professeur, parent_id, cours_description)




# @receiver(post_save, sender=Cours_Unite)
# def cours_unite_confirmed(sender, instance, **kwargs):
#     if instance.statut == 'C':  # Le cours est confirmé
#         envoyer_payment_notification(instance.user, instance)

# @receiver(post_save, sender=Cours_Package)
# def cours_package_confirmed(sender, instance, **kwargs):
#     if instance.est_actif:  # Le cours est actif
#         envoyer_payment_notification(instance.user, instance)
