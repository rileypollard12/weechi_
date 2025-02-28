from rest_framework import viewsets
from .models import Vehicle, VehicleBooking
from .serializers import VehicleSerializer, VehicleBookingSerializer
from django.contrib.auth.models import AnonymousUser
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny  # Or IsAuthenticated, depending on your needs

class VehicleViewSet(viewsets.ModelViewSet):
    queryset = Vehicle.objects.all()
    serializer_class = VehicleSerializer

    def get_queryset(self):
        return Vehicle.objects.all()


class VehicleBookingViewSet(viewsets.ModelViewSet):
    queryset = VehicleBooking.objects.all()
    serializer_class = VehicleBookingSerializer
    permission_classes = [IsAuthenticated]

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['request'] = self.request
        return context

    @action(detail=False, methods=['get'])
    def my_bookings(self, request):
        bookings = VehicleBooking.objects.filter(user=request.user)
        serializer = self.get_serializer(bookings, many=True)
        return Response(serializer.data)

class CheckVehicleAvailabilityView(APIView):
    permission_classes = [AllowAny]  # Or IsAuthenticated, depending on your needs

    def post(self, request):
        vehicle_id = request.data.get('vehicle_id')
        start_date = request.data.get('start_date')
        end_date = request.data.get('end_date')

        if not vehicle_id or not start_date or not end_date:
            return Response({'error': 'Missing parameters'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            vehicle = Vehicle.objects.get(pk=vehicle_id)
        except Vehicle.DoesNotExist:
            return Response({'error': 'Vehicle not found'}, status=status.HTTP_404_NOT_FOUND)

        # Check for overlapping bookings
        overlapping_bookings = VehicleBooking.objects.filter(
            vehicle=vehicle,
            start_date__lt=end_date,
            end_date__gt=start_date,
        )

        if overlapping_bookings.exists():
            return Response({'available': False})
        else:
            return Response({'available': True})