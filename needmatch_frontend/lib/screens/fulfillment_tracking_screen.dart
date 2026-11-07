import 'package:flutter/material.dart';

import '../services/api_service.dart';

class FulfillmentTrackingScreen extends StatefulWidget {
  final int fulfillmentId;

  const FulfillmentTrackingScreen({
    super.key,
    required this.fulfillmentId,
  });

  @override
  State<FulfillmentTrackingScreen> createState() =>
      _FulfillmentTrackingScreenState();
}

class _FulfillmentTrackingScreenState
    extends State<FulfillmentTrackingScreen> {
  Map<String, dynamic>? fulfillment;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadFulfillment();
  }

  Future<void> loadFulfillment() async {
    try {
      final data =
          await ApiService.getFulfillment(widget.fulfillmentId);

      if (!mounted) return;

      setState(() {
        fulfillment = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Fulfillment Tracking',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF168B45),
              ),
            )
          : errorMessage != null
              ? _errorView()
              : _trackingView(),
    );
  }

  Widget _trackingView() {
    final data = fulfillment!;

    final String resourceTitle =
        data['resource_title']?.toString() ?? 'Resource';

    final String requestTitle =
        data['request_title']?.toString() ?? 'Community Request';

    final String donor =
        data['donor_name']?.toString() ?? 'Contributor';

    final String requester =
        data['requester_name']?.toString() ?? 'Requester';

    final String status =
        data['status']?.toString() ?? 'REQUEST_CREATED';

    final String percentage =
        '${data['match_percentage'] ?? 0}%';

    return RefreshIndicator(
      onRefresh: loadFulfillment,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resourceTitle,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    'Request: $requestTitle',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Contributor: $donor',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Requester: $requester',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Text(
                        'Match: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        percentage,
                        style: const TextStyle(
                          color: Color(0xFF168B45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Current status: ${_statusText(status)}',
                    style: const TextStyle(
                      color: Color(0xFF168B45),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Fulfillment Progress',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            trackingStep(
              title: 'Request Created',
              subtitle: 'Request successfully created',
              icon: Icons.assignment_turned_in,
              currentStatus: status,
              stepStatus: 'REQUEST_CREATED',
            ),

            trackingStep(
              title: 'Match Accepted',
              subtitle: 'Contributor accepted the match',
              icon: Icons.handshake,
              currentStatus: status,
              stepStatus: 'MATCH_ACCEPTED',
            ),

            trackingStep(
              title: 'Verification',
              subtitle: 'Resource and contributor verified',
              icon: Icons.verified_user,
              currentStatus: status,
              stepStatus: 'VERIFICATION',
            ),

            trackingStep(
              title: 'Pickup',
              subtitle: 'Pickup scheduled',
              icon: Icons.inventory_2,
              currentStatus: status,
              stepStatus: 'PICKUP',
            ),

            trackingStep(
              title: 'Transportation',
              subtitle: 'Resource will be transported',
              icon: Icons.local_shipping_outlined,
              currentStatus: status,
              stepStatus: 'TRANSPORTATION',
            ),

            trackingStep(
              title: 'Delivery',
              subtitle: 'Resource delivered to recipient',
              icon: Icons.location_on_outlined,
              currentStatus: status,
              stepStatus: 'DELIVERY',
            ),

            trackingStep(
              title: 'Recipient Confirmation',
              subtitle: 'Recipient confirms receipt',
              icon: Icons.fact_check_outlined,
              currentStatus: status,
              stepStatus: 'RECIPIENT_CONFIRMATION',
            ),

            trackingStep(
              title: 'Completed',
              subtitle: 'Fulfillment successfully completed',
              icon: Icons.check_circle_outline,
              currentStatus: status,
              stepStatus: 'COMPLETED',
            ),

            if (data['notes'] != null &&
                data['notes'].toString().isNotEmpty) ...[
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['notes'].toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget trackingStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required String currentStatus,
    required String stepStatus,
  }) {
    final int currentIndex = _statusIndex(currentStatus);
    final int stepIndex = _statusIndex(stepStatus);

    final bool completed = currentIndex >= stepIndex;

    final bool current = currentStatus == stepStatus;

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: completed
                  ? const Color(0xFFEAF7EF)
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: completed
                  ? const Color(0xFF168B45)
                  : Colors.grey,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: current
                              ? const Color(0xFF168B45)
                              : Colors.black,
                        ),
                      ),
                    ),
                    if (completed)
                      const Icon(
                        Icons.check,
                        color: Color(0xFF168B45),
                        size: 20,
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _statusIndex(String status) {
    const statuses = [
      'REQUEST_CREATED',
      'MATCH_ACCEPTED',
      'VERIFICATION',
      'PICKUP',
      'TRANSPORTATION',
      'DELIVERY',
      'RECIPIENT_CONFIRMATION',
      'COMPLETED',
    ];

    final index = statuses.indexOf(status);

    return index == -1 ? 0 : index;
  }

  String _statusText(String status) {
    switch (status) {
      case 'REQUEST_CREATED':
        return 'Request Created';
      case 'MATCH_ACCEPTED':
        return 'Match Accepted';
      case 'VERIFICATION':
        return 'Verification';
      case 'PICKUP':
        return 'Pickup';
      case 'TRANSPORTATION':
        return 'Transportation';
      case 'DELIVERY':
        return 'Delivery';
      case 'RECIPIENT_CONFIRMATION':
        return 'Recipient Confirmation';
      case 'COMPLETED':
        return 'Completed';
      default:
        return status;
    }
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 50,
            ),
            const SizedBox(height: 15),
            Text(
              errorMessage ?? 'Unable to load fulfillment.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: loadFulfillment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF168B45),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}