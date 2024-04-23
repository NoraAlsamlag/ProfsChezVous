from rest_framework.decorators import api_view
from rest_framework.response import Response
from api.serializers import  *
from django.http import JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from .models import *
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import UserSerializer

from dj_rest_auth.registration.views import RegisterView
from user.serializers import *

class ParentRegisterView(RegisterView):
    serializer_class = ParentRegisterSerializer

class ProfesseurRegisterView(RegisterView):
    serializer_class = ProfesseurRegisterSerializer

class EleveRegisterView(RegisterView):
    serializer_class = EleveRegisterSerializer

class AdminRegisterView(RegisterView):
    serializer_class = AdminRegisterSerializer






@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_by_token(request):
    user = request.user  # Retrieve user object from request
    serializer = UserSerializer(user)
    return JsonResponse(serializer.data)

class ParentViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def list(self, request):
        # Retrieve the user based on the token
        user = request.user
        # Check if the user is a parent
        if user.is_parent:
            # Get the parent information associated with the user
            parent = Parent.objects.get(user=user)
            # Serialize the parent information
            serializer = ParentSerializer(parent)
            return JsonResponse(serializer.data)
        else:
            return Response({"message": "L'utilisateur n'est pas un parent."}, status=status.HTTP_403_FORBIDDEN)
        
from rest_framework import viewsets
from rest_framework.response import Response
from .models import Eleve, Professeur
from .serializers import EleveSerializer, ProfesseurSerializer

class EleveViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def list(self, request):
        user = request.user
        if user.is_eleve:
            eleve = Eleve.objects.get(user=user)
            serializer = EleveSerializer(eleve)
            return Response(serializer.data)
        else:
            return Response({"message": "L'utilisateur n'est pas un élève."}, status=403)

class ProfesseurViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def list(self, request):
        user = request.user
        if user.is_professeur:
            professeur = Professeur.objects.get(user=user)
            serializer = ProfesseurSerializer(professeur)
            return Response(serializer.data)
        else:
            return Response({"message": "L'utilisateur n'est pas un professeur."}, status=403)


@api_view(['GET'])
def getParents(request):
    parents= Parent.objects.all()
    serializer = ParentSerializer(parents, many=True)
    return  Response(serializer.data)

@api_view(['GET'])
def getParent(request, pk):
    parent= Parent.objects.get(id=pk) 
    serializer = ParentSerializer(parent, many=False)
    return  Response(serializer.data)

@api_view(["POST"])
def createParent(request):
    serializer = ParentSerializer(data=request.data)
    if serializer.is_valid():
        parent = serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)


@api_view(["PUT"])
def updateParent(request, pk):
    try:
        parent = Parent.objects.get(id=pk)
    except Parent.DoesNotExist:
        return Response({"error": "Parent non trouvé"}, status=404)

    serializer = ParentSerializer(parent, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=400)


@api_view(["DELETE"])
def deleteParent(request, pk):
    parent = Parent.objects.get(id=pk)

    parent.delete()
    return Response("Parent supprimé")