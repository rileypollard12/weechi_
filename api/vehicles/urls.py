from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import VehicleViewSet, VehicleBookingViewSet

router = DefaultRouter()
router.register(r'vehicles', VehicleViewSet)
router.register(r'vehicle_booking', VehicleBookingViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]