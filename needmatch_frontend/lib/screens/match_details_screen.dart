import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'fulfillment_tracking_screen.dart';

class MatchDetailsScreen extends StatefulWidget {
  final int matchId;

  const MatchDetailsScreen({
    super.key,
    required this.matchId,
  });

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  Map<String, dynamic>? match;
  bool isLoading = true;
  bool isAccepting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadMatch();
  }

  Future<void> loadMatch() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getMatch(widget.matchId);

      if (!mounted) return;

      setState(() {
        match = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> acceptMatch() async {
    if (isAccepting) return;

    setState(() {
      isAccepting = true;
    });

    try {
      final data = await ApiService.acceptMatch(widget.matchId);

      if (!mounted) return;

      final fulfillment = data['fulfillment'];

      if (fulfillment is Map<String, dynamic>) {
        final int fulfillmentId =
            int.tryParse(fulfillment['id'].toString()) ?? 0;

        if (fulfillmentId > 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FulfillmentTrackingScreen(
                fulfillmentId: fulfillmentId,
              ),
            ),
          );
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match accepted successfully.'),
          backgroundColor: Color(0xFF168B45),
        ),
      );

      await loadMatch();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isAccepting = false;
        });
      }
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
          'Match Details',
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
              : _detailsView(),
    );
  }

  Widget _detailsView() {
    final data = match!;

    final String title =
        data['resource_title']?.toString() ?? 'Resource';

    final String requestTitle =
        data['request_title']?.toString() ?? 'Community Request';

    final String donor =
        data['donor_name']?.toString() ?? 'Contributor';

    final String requester =
        data['requester_name']?.toString() ?? 'Requester';

    final String resourceLocation =
        data['resource_location']?.toString() ?? 'Unknown';

    final String requestLocation =
        data['request_location']?.toString() ?? 'Unknown';

    final String percentage =
        '${data['match_percentage'] ?? 0}%';

    final String status =
        data['status']?.toString() ?? 'PENDING';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF7EF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.handshake,
                    color: Color(0xFF168B45),
                    size: 42,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '$percentage Match',
                  style: const TextStyle(
                    color: Color(0xFF168B45),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                _statusChip(status),
              ],
            ),
          ),

          const SizedBox(height: 18),

          infoCard(
            Icons.inventory_2_outlined,
            'Available Resource',
            title,
          ),

          infoCard(
            Icons.assignment_outlined,
            'Requirement',
            requestTitle,
          ),

          infoCard(
            Icons.person_outline,
            'Contributor',
            donor,
          ),

          infoCard(
            Icons.person_pin_outlined,
            'Requester',
            requester,
          ),

          infoCard(
            Icons.location_on_outlined,
            'Resource Location',
            resourceLocation,
          ),

          infoCard(
            Icons.location_searching_outlined,
            'Request Location',
            requestLocation,
          ),

          const SizedBox(height: 20),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Match Factors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          factor('Resource Type', 'Matched'),
          factor('Location', 'Matched'),
          factor('Quantity', 'Matched'),
          factor('Urgency', 'Considered'),
          factor('Availability', 'Available'),

          const SizedBox(height: 25),

          if (status == 'PENDING')
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isAccepting ? null : acceptMatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF168B45),
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isAccepting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Accept Match',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            )
          else if (status == 'ACCEPTED')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7EF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF168B45),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This match has been accepted.',
                      style: TextStyle(
                        color: Color(0xFF168B45),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    String text;

    switch (status) {
      case 'PENDING':
        text = 'Pending';
        break;
      case 'ACCEPTED':
        text = 'Accepted';
        break;
      case 'REJECTED':
        text = 'Rejected';
        break;
      case 'COMPLETED':
        text = 'Completed';
        break;
      default:
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF168B45),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
              errorMessage ?? 'Unable to load match.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: loadMatch,
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

  Widget infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF168B45),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget factor(
    String name,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(name),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF168B45),
            ),
          ),
        ],
      ),
    );
  }
}
