from django.urls import path

from .views import (
    RegisterView,
    UserDetailView,
    LoginView,
    ResourceListCreateView,
    ResourceDetailView,
    RequestListCreateView,
    RequestDetailView,
    MatchListView,
    GenerateMatchesView,
    MatchDetailView,
    AcceptMatchView,
    FulfillmentListView,
    FulfillmentDetailView,
)


urlpatterns = [

    # Authentication
    path(
        'register/',
        RegisterView.as_view(),
        name='register'
    ),

    path(
        'users/<int:pk>/',
        UserDetailView.as_view(),
        name='user-detail'
    ),

    path(
        'login/',
        LoginView.as_view(),
        name='login'
    ),

    # Resources
    path(
        'resources/',
        ResourceListCreateView.as_view(),
        name='resources'
    ),

    path(
        'resources/<int:pk>/',
        ResourceDetailView.as_view(),
        name='resource-detail'
    ),

    # Requests
    path(
        'requests/',
        RequestListCreateView.as_view(),
        name='requests'
    ),

    path(
        'requests/<int:pk>/',
        RequestDetailView.as_view(),
        name='request-detail'
    ),
    
    # Matches

    path(
        'matches/',
        MatchListView.as_view(),
        name='matches'
    ),

    path(
        'resources/<int:resource_id>/generate-matches/',
        GenerateMatchesView.as_view(),
        name='generate-matches'
    ),

    path(
        'matches/<int:pk>/',
        MatchDetailView.as_view(),
        name='match-detail'
    ),

    path(
        'matches/<int:pk>/accept/',
        AcceptMatchView.as_view(),
        name='accept-match'
    ),

    path(
        'fulfillments/',
        FulfillmentListView.as_view(),
        name='fulfillments'
    ),

    path(
        'fulfillments/<int:pk>/',
        FulfillmentDetailView.as_view(),
        name='fulfillment-detail'
    ),
]