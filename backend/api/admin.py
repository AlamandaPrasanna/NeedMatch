from django.contrib import admin

from .models import (
    User,
    Resource,
    Request,
    Match,
    Fulfillment,
    VolunteerOpportunity,
    VolunteerApplication,
    Notification,
    ImpactRecord,
)


admin.site.register(User)
admin.site.register(Resource)
admin.site.register(Request)
admin.site.register(Match)
admin.site.register(Fulfillment)
admin.site.register(VolunteerOpportunity)
admin.site.register(VolunteerApplication)
admin.site.register(Notification)
admin.site.register(ImpactRecord)