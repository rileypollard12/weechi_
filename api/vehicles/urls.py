from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import VehicleViewSet, VehicleBookingViewSet, CheckVehicleAvailabilityView

router = DefaultRouter()
router.register(r'vehicles', VehicleViewSet)
router.register(r'vehicle_booking', VehicleBookingViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
    path('api/check_availability/', CheckVehicleAvailabilityView.as_view(), name='check_availability'),

]