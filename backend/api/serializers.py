from rest_framework import serializers

from .models import (
    User,
    Resource,
    Request,
    Match,
    Fulfillment,
)

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            'id',
            'name',
            'email',
            'phone',
            'location',
            'profile_image',
            'created_at',
        ]
        read_only_fields = ['id', 'created_at']


class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            'id',
            'name',
            'email',
            'password',
            'phone',
            'location',
        ]
        extra_kwargs = {
            'password': {
                'write_only': True
            }
        }

    def create(self, validated_data):
        return User.objects.create(**validated_data)


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)


class ResourceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Resource
        fields = [
            'id',
            'user',
            'title',
            'category',
            'quantity',
            'location',
            'description',
            'status',
            'created_at',
        ]
        read_only_fields = [
            'id',
            'status',
            'created_at',
        ]


class RequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = Request
        fields = [
            'id',
            'user',
            'title',
            'category',
            'quantity',
            'location',
            'urgency',
            'description',
            'status',
            'created_at',
        ]
        read_only_fields = [
            'id',
            'status',
            'created_at',
        ]
        
        
class MatchSerializer(serializers.ModelSerializer):
    resource_title = serializers.CharField(
        source='resource.title',
        read_only=True
    )

    request_title = serializers.CharField(
        source='request.title',
        read_only=True
    )

    donor_name = serializers.CharField(
        source='resource.user.name',
        read_only=True
    )

    requester_name = serializers.CharField(
        source='request.user.name',
        read_only=True
    )

    resource_location = serializers.CharField(
        source='resource.location',
        read_only=True
    )

    request_location = serializers.CharField(
        source='request.location',
        read_only=True
    )

    class Meta:
        model = Match
        fields = [
            'id',
            'resource',
            'resource_title',
            'request',
            'request_title',
            'donor_name',
            'requester_name',
            'resource_location',
            'request_location',
            'match_percentage',
            'status',
            'created_at',
        ]

        read_only_fields = [
            'id',
            'match_percentage',
            'status',
            'created_at',
        ]
        
        
class FulfillmentSerializer(serializers.ModelSerializer):

    match_percentage = serializers.DecimalField(
        source='match.match_percentage',
        max_digits=5,
        decimal_places=2,
        read_only=True
    )

    resource_title = serializers.CharField(
        source='match.resource.title',
        read_only=True
    )

    request_title = serializers.CharField(
        source='match.request.title',
        read_only=True
    )

    donor_name = serializers.CharField(
        source='match.resource.user.name',
        read_only=True
    )

    requester_name = serializers.CharField(
        source='match.request.user.name',
        read_only=True
    )

    class Meta:
        model = Fulfillment

        fields = [
            'id',
            'match',
            'match_percentage',
            'resource_title',
            'request_title',
            'donor_name',
            'requester_name',
            'status',
            'pickup_date',
            'delivery_date',
            'notes',
            'created_at',
        ]

        read_only_fields = [
            'id',
            'match_percentage',
            'resource_title',
            'request_title',
            'donor_name',
            'requester_name',
            'created_at',
        ]