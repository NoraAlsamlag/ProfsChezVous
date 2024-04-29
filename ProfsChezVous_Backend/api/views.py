from rest_framework import generics
from rest_framework import viewsets
#from .models import DiscussionParentAdmin
#from .serializers import DiscussionParentAdminSerializer
from .models import Transaction ,Evaluation,Message,CommentaireCours,Matiere,Cours_Package,Cours_Unite
from .serializers import *






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



class MessageViewSet(viewsets.ModelViewSet):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer 

class TransactionListView(generics.ListCreateAPIView):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer

class TransactionDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer 


class EvaluationListAPIView(generics.ListCreateAPIView):
    queryset = Evaluation.objects.all()
    serializer_class = EvaluationSerializer

class EvaluationRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Evaluation.objects.all()
    serializer_class = EvaluationSerializer
