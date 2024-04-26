from rest_framework import generics
from .models import Matiere, CommentaireCours
from .serializers import MatiereSerializer, CommentaireCoursSerializer
from rest_framework import viewsets
from .models import Cours_Unite
from .serializers import CoursUniteSerializer
from .models import Cours_Package
from .serializers import CoursPackageSerializer
from rest_framework import viewsets
from .models import DiscussionParentAdmin
from .serializers import DiscussionParentAdminSerializer







class MatiereList(generics.ListCreateAPIView):
    queryset = Matiere.objects.all()
    serializer_class = MatiereSerializer

class MatiereDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Matiere.objects.all()
    serializer_class = MatiereSerializer

class CommentaireCoursList(generics.ListCreateAPIView):
    queryset = CommentaireCours.objects.all()
    serializer_class = CommentaireCoursSerializer

class CommentaireCoursDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = CommentaireCours.objects.all()
    serializer_class = CommentaireCoursSerializer

class CoursUniteViewSet(viewsets.ModelViewSet):
    queryset = Cours_Unite.objects.all()
    serializer_class = CoursUniteSerializer

class CoursPackageViewSet(viewsets.ModelViewSet):
    queryset = Cours_Package.objects.all()
    serializer_class = CoursPackageSerializer 

class DiscussionParentAdminViewSet(viewsets.ModelViewSet):
    queryset = DiscussionParentAdmin.objects.all()
    serializer_class = DiscussionParentAdminSerializer