from rest_framework import serializers
from .models import Vehicle, VehicleBooking
from rest_framework.exceptions import ValidationError
from django.utils import timezone

class VehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        fields = '__all__'

class VehicleBookingSerializer(serializers.ModelSerializer):
    vehicle = serializers.PrimaryKeyRelatedField(queryset=Vehicle.objects.none())
    user = serializers.PrimaryKeyRelatedField(read_only=True, default=serializers.CurrentUserDefault())

    class Meta:
        model = VehicleBooking
        fields = '__all__'
        read_only_fields = ('user',)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        user = self.context['request'].user
        self.fields['vehicle'].queryset = Vehicle.objects.filter(department__in=user.departments.all())

    def validate(self, data):
        """
        Check that the start_date is before the end_date.
        Also, check for overlapping bookings.
        """
        start_date = data.get('start_date')
        end_date = data.get('end_date')
        vehicle = data.get('vehicle')

        if start_date and end_date:
            if start_date >= end_date:
                raise serializers.ValidationError("Start date must be before end date.")

        if vehicle and start_date and end_date:
            # Check for overlapping bookings
            overlapping_bookings = VehicleBooking.objects.filter(
                vehicle=vehicle,
                start_date__lt=end_date,
                end_date__gt=start_date,
            )

            # If this is an update, exclude the current booking from the check
            if self.instance:
                overlapping_bookings = overlapping_bookings.exclude(pk=self.instance.pk)

            if overlapping_bookings.exists():
                raise serializers.ValidationError("This vehicle is already booked for the selected dates.")

        return data

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)