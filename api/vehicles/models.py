from django.db import models
from organization.models import Department  # Import the Department model
from django.contrib.auth.models import User  # Import the User model

class Vehicle(models.Model):
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    plate = models.CharField(max_length=10)
    year = models.PositiveIntegerField()
    make = models.CharField(max_length=50)
    model = models.CharField(max_length=50)
    color = models.CharField(max_length=30)
    vin = models.CharField(max_length=17, unique=True)

    def __str__(self):
        return f"{self.year} {self.make} {self.model} ({self.plate})"

class VehicleBooking(models.Model):
    vehicle = models.ForeignKey(Vehicle, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    purpose = models.CharField(max_length=255)

    def __str__(self):
        return f"Booking for {self.vehicle} by {self.user} from {self.start_date} to {self.end_date}"