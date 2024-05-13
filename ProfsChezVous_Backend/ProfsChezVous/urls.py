
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from rest_framework.authtoken.views import obtain_auth_token # <-- NEW

urlpatterns = [
    path('', include('home.urls')),
    path("admin/", admin.site.urls),
    path('api/', include('api.urls')),
    path('user/', include('user.urls')),
    path("", include('admin_datta.urls')),
    path('', include('django_dyn_dt.urls')),
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# Lazy-load on routing is needed
# During the first build, API is not yet generated
try:
    urlpatterns.append( path("api/"      , include("api.urls"))    )
    urlpatterns.append( path("login/jwt/", view=obtain_auth_token) )
except:
    pass