import 'package:flutter/material.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() =>
      _VolunteerScreenState();
}

class _VolunteerScreenState
    extends State<VolunteerScreen> {

  bool available = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Volunteer',
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFFEAF7EF),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [

                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,

                    child: Icon(
                      Icons.volunteer_activism,
                      color: Color(0xFF168B45),
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Make an Impact',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Share your time and skills with your community.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(17),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Available for volunteering',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Allow NeedMatch to show suitable opportunities.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Switch(
                    value: available,

                    activeColor:
                        const Color(0xFF168B45),

                    onChanged: (value) {
                      setState(() {
                        available = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Volunteer Opportunities',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            volunteerCard(
              title: 'Teach School Students',
              category: 'Education',
              time: '4 hours/week',
              location: 'Nearby',
              icon: Icons.school_outlined,
            ),

            volunteerCard(
              title: 'Food Distribution',
              category: 'Food Support',
              time: '3 hours',
              location: '5 km away',
              icon: Icons.restaurant_outlined,
            ),

            volunteerCard(
              title: 'Pickup & Delivery',
              category: 'Transportation',
              time: 'Flexible',
              location: 'Nearby',
              icon: Icons.local_shipping_outlined,
            ),

            volunteerCard(
              title: 'Animal Shelter Support',
              category: 'Animal Welfare',
              time: 'Weekend',
              location: '8 km away',
              icon: Icons.pets_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget volunteerCard({
    required String title,
    required String category,
    required String time,
    required String location,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [

          Container(
            width: 55,
            height: 55,

            decoration: const BoxDecoration(
              color: Color(0xFFFFF3DE),
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: Color(0xFFE89A20),
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

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
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE89A20),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$time • $location',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}