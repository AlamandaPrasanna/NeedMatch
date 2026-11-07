from django.shortcuts import get_object_or_404

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import *
from .matching import *
from .serializers import *

from .models import User, Resource, Request
from .serializers import (
    RegisterSerializer,
    LoginSerializer,
    UserSerializer,
    ResourceSerializer,
    RequestSerializer,
)


# -------------------------
# REGISTER
# -------------------------

class RegisterView(APIView):

    def post(self, request):

        serializer = RegisterSerializer(data=request.data)

        if serializer.is_valid():

            email = serializer.validated_data['email']

            if User.objects.filter(email=email).exists():
                return Response(
                    {
                        'message': 'Email already registered.'
                    },
                    status=status.HTTP_400_BAD_REQUEST
                )

            user = serializer.save()

            return Response(
                {
                    'message': 'Account created successfully.',
                    'user': UserSerializer(user).data
                },
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


class UserDetailView(APIView):

    def get(self, request, pk):
        user = get_object_or_404(User, pk=pk)
        return Response(UserSerializer(user).data)

    def put(self, request, pk):
        user = get_object_or_404(User, pk=pk)
        serializer = UserSerializer(
            user,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():
            user = serializer.save()
            return Response(UserSerializer(user).data)

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


# -------------------------
# LOGIN
# -------------------------

class LoginView(APIView):

    def post(self, request):

        serializer = LoginSerializer(data=request.data)

        if not serializer.is_valid():
            return Response(
                serializer.errors,
                status=status.HTTP_400_BAD_REQUEST
            )

        email = serializer.validated_data['email']
        password = serializer.validated_data['password']

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response(
                {
                    'message': 'Invalid email or password.'
                },
                status=status.HTTP_401_UNAUTHORIZED
            )

        if user.password != password:
            return Response(
                {
                    'message': 'Invalid email or password.'
                },
                status=status.HTTP_401_UNAUTHORIZED
            )

        return Response(
            {
                'message': 'Login successful.',
                'user': UserSerializer(user).data
            },
            status=status.HTTP_200_OK
        )


# -------------------------
# RESOURCES
# -------------------------

class ResourceListCreateView(APIView):

    def get(self, request):

        resources = Resource.objects.all().order_by('-created_at')

        serializer = ResourceSerializer(
            resources,
            many=True
        )

        return Response(serializer.data)

    def post(self, request):

        serializer = ResourceSerializer(
            data=request.data
        )

        if serializer.is_valid():

            resource = serializer.save()

            return Response(
                ResourceSerializer(resource).data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


# -------------------------
# SINGLE RESOURCE
# -------------------------

class ResourceDetailView(APIView):

    def get(self, request, pk):

        resource = get_object_or_404(
            Resource,
            pk=pk
        )

        serializer = ResourceSerializer(resource)

        return Response(serializer.data)

    def put(self, request, pk):

        resource = get_object_or_404(
            Resource,
            pk=pk
        )

        serializer = ResourceSerializer(
            resource,
            data=request.data
        )

        if serializer.is_valid():

            resource = serializer.save()

            return Response(
                ResourceSerializer(resource).data
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def delete(self, request, pk):

        resource = get_object_or_404(
            Resource,
            pk=pk
        )

        resource.delete()

        return Response(
            {
                'message': 'Resource deleted successfully.'
            },
            status=status.HTTP_204_NO_CONTENT
        )


# -------------------------
# REQUESTS
# -------------------------

class RequestListCreateView(APIView):

    def get(self, request):

        requests = Request.objects.all().order_by('-created_at')

        serializer = RequestSerializer(
            requests,
            many=True
        )

        return Response(serializer.data)

    def post(self, request):

        serializer = RequestSerializer(
            data=request.data
        )

        if serializer.is_valid():

            user_id = request.data.get('user')

            if not user_id:
                return Response(
                    {
                        'message': 'User is required.'
                    },
                    status=status.HTTP_400_BAD_REQUEST
                )

            resource_request = serializer.save()

            return Response(
                RequestSerializer(resource_request).data,
                status=status.HTTP_201_CREATED
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )


# -------------------------
# SINGLE REQUEST
# -------------------------

class RequestDetailView(APIView):

    def get(self, request, pk):

        resource_request = get_object_or_404(
            Request,
            pk=pk
        )

        serializer = RequestSerializer(
            resource_request
        )

        return Response(serializer.data)

    def put(self, request, pk):

        resource_request = get_object_or_404(
            Request,
            pk=pk
        )

        serializer = RequestSerializer(
            resource_request,
            data=request.data
        )

        if serializer.is_valid():

            resource_request = serializer.save()

            return Response(
                RequestSerializer(resource_request).data
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )

    def delete(self, request, pk):

        resource_request = get_object_or_404(
            Request,
            pk=pk
        )

        resource_request.delete()

        return Response(
            {
                'message': 'Request deleted successfully.'
            },
            status=status.HTTP_204_NO_CONTENT
        )
        

# -------------------------
# MATCH LIST
# -------------------------

class MatchListView(APIView):

    def get(self, request):

        matches = Match.objects.all().order_by(
            '-match_percentage'
        )

        from .serializers import MatchSerializer

        serializer = MatchSerializer(
            matches,
            many=True
        )

        return Response(serializer.data)


# -------------------------
# GENERATE MATCHES
# -------------------------

class GenerateMatchesView(APIView):

    def post(self, request, resource_id):

        resource = get_object_or_404(
            Resource,
            pk=resource_id
        )

        matches = generate_matches_for_resource(
            resource
        )

        from .serializers import MatchSerializer

        serializer = MatchSerializer(
            matches,
            many=True
        )

        return Response(
            {
                'message': 'Matches generated successfully.',
                'matches': serializer.data
            },
            status=status.HTTP_200_OK
        )


# -------------------------
# MATCH DETAILS
# -------------------------

class MatchDetailView(APIView):

    def get(self, request, pk):

        match = get_object_or_404(
            Match,
            pk=pk
        )

        from .serializers import MatchSerializer

        serializer = MatchSerializer(match)

        return Response(serializer.data)


# -------------------------
# ACCEPT MATCH
# -------------------------

class AcceptMatchView(APIView):

    def post(self, request, pk):

        match = get_object_or_404(
            Match,
            pk=pk
        )

        if match.status == 'COMPLETED':
            return Response(
                {
                    'message': 'This match is already completed.'
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        match.status = 'ACCEPTED'
        match.save()

        fulfillment, created = Fulfillment.objects.get_or_create(
            match=match,
            defaults={
                'status': 'MATCH_ACCEPTED'
            }
        )

        if not created:
            fulfillment.status = 'MATCH_ACCEPTED'
            fulfillment.save()

        return Response(
            {
                'message': 'Match accepted successfully.',
                'match_id': match.id,
                'match_status': match.status,
                'fulfillment': FulfillmentSerializer(
                    fulfillment
                ).data
            },
            status=status.HTTP_200_OK
        )
        
        
class FulfillmentListView(APIView):

    def get(self, request):

        fulfillments = Fulfillment.objects.all().order_by(
            '-created_at'
        )

        serializer = FulfillmentSerializer(
            fulfillments,
            many=True
        )

        return Response(serializer.data)
    
    
class FulfillmentDetailView(APIView):

    def get(self, request, pk):

        fulfillment = get_object_or_404(
            Fulfillment,
            pk=pk
        )

        serializer = FulfillmentSerializer(
            fulfillment
        )

        return Response(serializer.data)

    def put(self, request, pk):

        fulfillment = get_object_or_404(
            Fulfillment,
            pk=pk
        )

        serializer = FulfillmentSerializer(
            fulfillment,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():

            fulfillment = serializer.save()

            return Response(
                FulfillmentSerializer(
                    fulfillment
                ).data
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )