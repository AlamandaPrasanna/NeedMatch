from django.db import models


class User(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)
    phone = models.CharField(max_length=20, blank=True)
    location = models.CharField(max_length=255, blank=True)
    profile_image = models.URLField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class Resource(models.Model):

    STATUS_CHOICES = [
        ('AVAILABLE', 'Available'),
        ('MATCHED', 'Matched'),
        ('FULFILLED', 'Fulfilled'),
        ('CANCELLED', 'Cancelled'),
    ]

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='resources'
    )

    title = models.CharField(max_length=200)
    category = models.CharField(max_length=100)
    quantity = models.PositiveIntegerField()
    location = models.CharField(max_length=255)
    description = models.TextField(blank=True)

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='AVAILABLE'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title


class Request(models.Model):

    URGENCY_CHOICES = [
        ('LOW', 'Low'),
        ('MEDIUM', 'Medium'),
        ('HIGH', 'High'),
        ('URGENT', 'Urgent'),
    ]

    STATUS_CHOICES = [
        ('OPEN', 'Open'),
        ('PARTIALLY_FULFILLED', 'Partially Fulfilled'),
        ('FULFILLED', 'Fulfilled'),
        ('CANCELLED', 'Cancelled'),
    ]

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='requests'
    )

    title = models.CharField(max_length=200)
    category = models.CharField(max_length=100)
    quantity = models.PositiveIntegerField()
    location = models.CharField(max_length=255)

    urgency = models.CharField(
        max_length=10,
        choices=URGENCY_CHOICES,
        default='MEDIUM'
    )

    description = models.TextField(blank=True)

    status = models.CharField(
        max_length=25,
        choices=STATUS_CHOICES,
        default='OPEN'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title


class Match(models.Model):

    STATUS_CHOICES = [
        ('PENDING', 'Pending'),
        ('ACCEPTED', 'Accepted'),
        ('REJECTED', 'Rejected'),
        ('COMPLETED', 'Completed'),
    ]

    resource = models.ForeignKey(
        Resource,
        on_delete=models.CASCADE,
        related_name='matches'
    )

    request = models.ForeignKey(
        Request,
        on_delete=models.CASCADE,
        related_name='matches'
    )

    match_percentage = models.DecimalField(
        max_digits=5,
        decimal_places=2
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='PENDING'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.resource.title} → {self.request.title}"


class Fulfillment(models.Model):

    STATUS_CHOICES = [
        ('REQUEST_CREATED', 'Request Created'),
        ('MATCH_ACCEPTED', 'Match Accepted'),
        ('VERIFICATION', 'Verification'),
        ('PICKUP', 'Pickup'),
        ('TRANSPORTATION', 'Transportation'),
        ('DELIVERY', 'Delivery'),
        ('RECIPIENT_CONFIRMATION', 'Recipient Confirmation'),
        ('COMPLETED', 'Completed'),
    ]

    match = models.OneToOneField(
        Match,
        on_delete=models.CASCADE,
        related_name='fulfillment'
    )

    status = models.CharField(
        max_length=30,
        choices=STATUS_CHOICES,
        default='REQUEST_CREATED'
    )

    pickup_date = models.DateTimeField(null=True, blank=True)
    delivery_date = models.DateTimeField(null=True, blank=True)

    notes = models.TextField(blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Fulfillment #{self.id}"


class VolunteerOpportunity(models.Model):

    STATUS_CHOICES = [
        ('OPEN', 'Open'),
        ('FULL', 'Full'),
        ('COMPLETED', 'Completed'),
        ('CANCELLED', 'Cancelled'),
    ]

    title = models.CharField(max_length=200)
    description = models.TextField()
    location = models.CharField(max_length=255)

    required_volunteers = models.PositiveIntegerField(default=1)

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='OPEN'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title


class VolunteerApplication(models.Model):

    STATUS_CHOICES = [
        ('PENDING', 'Pending'),
        ('APPROVED', 'Approved'),
        ('REJECTED', 'Rejected'),
        ('COMPLETED', 'Completed'),
    ]

    volunteer = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='volunteer_applications'
    )

    opportunity = models.ForeignKey(
        VolunteerOpportunity,
        on_delete=models.CASCADE,
        related_name='applications'
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='PENDING'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.volunteer.name} - {self.opportunity.title}"


class Notification(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='notifications'
    )

    title = models.CharField(max_length=200)
    message = models.TextField()

    is_read = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title


class ImpactRecord(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='impact_records'
    )

    contribution_type = models.CharField(max_length=100)
    quantity = models.PositiveIntegerField(default=1)
    people_helped = models.PositiveIntegerField(default=0)
    hours_contributed = models.DecimalField(
        max_digits=8,
        decimal_places=2,
        default=0
    )

    description = models.TextField(blank=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.name} - {self.contribution_type}"