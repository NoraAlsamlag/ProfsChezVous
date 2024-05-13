from django import forms
class InscrireEnfantForm(forms.Form):
    prenom = forms.CharField(max_length=30)
    nom = forms.CharField(max_length=50)
    date_naissance = forms.DateField()
    niveau_scolaire = forms.CharField(max_length=100)
    etablissement = forms.CharField(max_length=100)