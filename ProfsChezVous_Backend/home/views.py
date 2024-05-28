from django.shortcuts import render, get_object_or_404
from admin_datta.forms import RegistrationForm, LoginForm, UserPasswordChangeForm, UserPasswordResetForm, UserSetPasswordForm
from django.contrib.auth.views import LoginView, PasswordChangeView, PasswordResetConfirmView, PasswordResetView
from django.views.generic import CreateView
from django.contrib.auth import logout
from django.contrib.auth.decorators import login_required
from .models import *
from user.models import User, Parent, Professeur, Eleve
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.http import JsonResponse
from django.db.models import Sum, Count
from datetime import datetime
from api.models import Cours_Unite, Cours_Package

def index(request):
    # Nombre total d'utilisateurs de chaque type
    nombre_parents = Parent.objects.count()
    nombre_professeurs = Professeur.objects.count()
    nombre_eleves = Eleve.objects.count()

    # Montant mensuel et annuel des cours
    mois_actuel = datetime.now().month
    annee_actuelle = datetime.now().year
    revenu_total_mensuel = Cours_Unite.objects.filter(date__month=mois_actuel).aggregate(Sum('prix'))['prix__sum'] or 0
    revenu_total_annuel = Cours_Unite.objects.filter(date__year=annee_actuelle).aggregate(Sum('prix'))['prix__sum'] or 0

    # Statistiques des cours pour chaque type d'utilisateur
    nombre_cours_unite = Cours_Unite.objects.filter(user__isnull=False).count()
    nombre_cours_package = Cours_Package.objects.filter(user__isnull=False).count()

    # Calculer le nombre total d'utilisateurs
    nombre_total_utilisateurs = nombre_parents + nombre_professeurs + nombre_eleves

    # Utilisateurs actifs et inactifs
    parents_actifs = Parent.objects.filter(user__is_active=True).count()
    parents_inactifs = Parent.objects.filter(user__is_active=False).count()
    professeurs_actifs = Professeur.objects.filter(user__is_active=True).count()
    professeurs_inactifs = Professeur.objects.filter(user__is_active=False).count()
    eleves_actifs = Eleve.objects.filter(user__is_active=True).count()
    eleves_inactifs = Eleve.objects.filter(user__is_active=False).count()

    context = {
        'nombre_parents': nombre_parents,
        'nombre_professeurs': nombre_professeurs,
        'nombre_eleves': nombre_eleves,
        'revenu_total_mensuel': revenu_total_mensuel,
        'revenu_total_annuel': revenu_total_annuel,
        'nombre_cours_unite': nombre_cours_unite,
        'nombre_cours_package': nombre_cours_package,
        'nombre_total_utilisateurs': nombre_total_utilisateurs,
        'parents_actifs': parents_actifs,
        'parents_inactifs': parents_inactifs,
        'professeurs_actifs': professeurs_actifs,
        'professeurs_inactifs': professeurs_inactifs,
        'eleves_actifs': eleves_actifs,
        'eleves_inactifs': eleves_inactifs,
    }

    return render(request, "pages/index.html", context)

# @csrf_exempt
# @require_POST
# def toggle_user_status(request, user_id):
#     user = get_object_or_404(User, id=user_id)
#     user.is_active = not user.is_active
#     user.save()
#     return JsonResponse({'status': user.is_active})

# def tables(request):
#   # context = {
#   #   'segment': 'tables'
#   # }
#   users = User.objects.all()
#   return render(request, "pages/dynamic-tables.html", {'users': users})
# @csrf_exempt
# @require_POST
# def toggle_user_status(request, user_id):
#     user = get_object_or_404(User, id=user_id)
#     user.is_active = not user.is_active
#     user.save()
#     return JsonResponse({'status': user.is_active})
def tables(request):
    users = User.objects.all()
    return render(request, "pages/dynamic-tables.html", {'users': users})

@csrf_exempt
@require_POST
def toggle_user_status(request, user_id):
    user = get_object_or_404(User, id=user_id)
    user.is_active = not user.is_active
    user.save()
    return JsonResponse({'status': user.is_active})