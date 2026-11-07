from .models import Resource, Request, Match


def calculate_match(resource, request):
    score = 0

    # 1. Category match
    if resource.category.lower() == request.category.lower():
        score += 35

    # 2. Location match
    if resource.location.lower() == request.location.lower():
        score += 25

    # 3. Quantity
    if resource.quantity >= request.quantity:
        score += 20
    elif resource.quantity > 0:
        score += 10

    # 4. Urgency
    urgency_scores = {
        'LOW': 5,
        'MEDIUM': 10,
        'HIGH': 15,
        'URGENT': 20,
    }

    score += urgency_scores.get(request.urgency, 10)

    return min(score, 100)


def generate_matches_for_resource(resource):
    requests = Request.objects.filter(
        status__in=['OPEN', 'PARTIALLY_FULFILLED']
    )

    matches = []

    for request in requests:

        # Don't match a resource with its own request
        if resource.user_id == request.user_id:
            continue

        percentage = calculate_match(
            resource,
            request
        )

        # Only create useful matches
        if percentage >= 50:

            match, created = Match.objects.get_or_create(
                resource=resource,
                request=request,
                defaults={
                    'match_percentage': percentage,
                    'status': 'PENDING',
                }
            )

            # Update percentage if match already exists
            if not created:
                match.match_percentage = percentage
                match.save()

            matches.append(match)

    return matches