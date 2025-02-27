from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import LocationViewSet, DepartmentViewSet, LoginView

router = DefaultRouter()
router.register(r'locations', LocationViewSet)
router.register(r'departments', DepartmentViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
    path('api/login/', LoginView.as_view(), name='login'),
]