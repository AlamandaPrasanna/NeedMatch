import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Notifications',
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

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          notificationCard(
            icon: Icons.handshake_outlined,
            title: 'New Match Found',
            description:
                'Your school book resource matches a community request.',
            time: '10 minutes ago',
          ),

          notificationCard(
            icon: Icons.local_shipping_outlined,
            title: 'Pickup Scheduled',
            description:
                'Pickup for your donated items has been scheduled.',
            time: '1 hour ago',
          ),

          notificationCard(
            icon: Icons.check_circle_outline,
            title: 'Contribution Completed',
            description:
                'Your food contribution was successfully delivered.',
            time: 'Yesterday',
          ),

          notificationCard(
            icon: Icons.volunteer_activism_outlined,
            title: 'Volunteer Opportunity',
            description:
                'A nearby community activity needs volunteers.',
            time: 'Yesterday',
          ),

          notificationCard(
            icon: Icons.favorite_outline,
            title: 'Impact Updated',
            description:
                'Your contribution has helped 5 people.',
            time: '2 days ago',
          ),
        ],
      ),
    );
  }

  Widget notificationCard({
    required IconData icon,
    required String title,
    required String description,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            width: 48,
            height: 48,

            decoration: const BoxDecoration(
              color: Color(0xFFEAF7EF),
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: Color(0xFF168B45),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
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
}