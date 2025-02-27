from rest_framework import viewsets
from .models import Vehicle, VehicleBooking
from .serializers import VehicleSerializer, VehicleBookingSerializer

class VehicleViewSet(viewsets.ModelViewSet):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer

    def get_queryset(self):
        user = self.request.user
        return Vehicle.objects.filter(department__in=user.departments.all())

class VehicleBookingViewSet(viewsets.ModelViewSet):
    queryset = VehicleBooking.objects.all()
    serializer_class = VehicleBookingSerializer

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['request'] = self.request
        return context