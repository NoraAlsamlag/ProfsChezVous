from django.contrib import admin

# Register your models here.

from  user.models import (Parent,Professeur,Eleve,User)
from .models import (Matiere,CommentaireCours,Cours,DiscussionParentAdmin,DiscussionProfAdmin,Message)
admin.site.register(Parent)
admin.site.register(Professeur)
admin.site.register(Matiere)
admin.site.register(Eleve)
admin.site.register(CommentaireCours)
admin.site.register(Cours)
admin.site.register(DiscussionParentAdmin)
admin.site.register(DiscussionProfAdmin)
admin.site.register(Message)
admin.site.register(User)
