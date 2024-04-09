from rest_framework.decorators import api_view
from rest_framework.response import Response
from api.serializers import  *
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