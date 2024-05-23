from django.contrib import admin

# Register your models here.

from  user.models import *
from .models import *
admin.site.register(Parent)
admin.site.register(Professeur)
admin.site.register(Matiere)
admin.site.register(Eleve)
admin.site.register(CommentaireCours)
admin.site.register(Message)
admin.site.register(Disponibilite)
admin.site.register(Notification)
admin.site.register(Cours_Package)
admin.site.register(Cours_Unite)
admin.site.register(PrixDeBasePackage)
admin.site.register(PrixDeBaseUnite)
admin.site.register(User)
admin.site.register(Enfant)
admin.site.register(Admin)
