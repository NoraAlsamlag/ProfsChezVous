from django.contrib.auth.models import User
from .models import Parent

# Créer un nouvel utilisateur
user = User.objects.create_user(username='moooool', password='MMMoo&88')

# Créer un objet Parent par défaut pour cet utilisateur
parent = Parent.objects.create(
    utilisateur=user,
    nom='ahmed',
    prenom='mahmoud',
    numero_telephone='5550006566',
    adresse='tyfghji768'
)

print(f"Utilisateur créé : {user.username}")
print(f"Parent par défaut créé pour l'utilisateur {user.username} : {parent}")