from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers
from user.models import User

class CustomRegisterSerializer(RegisterSerializer):
    nom=serializers.CharField()
    prenom=serializers.CharField()
    numero_telephone=serializers.CharField()
    role = serializers.ChoiceField(choices=User.Role.choices, default=User.Role.ADMIN)
    def custom_signup(self, request, user):
        user.first_name=request.data['first_name']
        user.last_name=request.data['last_name']
        user.numero_telephone=request.data['numero_telephone']
        user.role = request.data['role']
        user.save()

class CustomLoginSerializer(LoginSerializer):
    pass