from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import  *
from .models import *

@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint':'/api/get_all', 
            'Method':"GET",
            'body':None,
            'Description':'Returns all available data in the database'
        },
        {
            "Endpoint":"/api/add_data",
            "Method": "POST",
            "Body":{
                "Title":"String, required",
                "Content":"String, required"
            },
            "Description":"Add a new blog post to the database."
        }
    ]
    return Response(routes)
