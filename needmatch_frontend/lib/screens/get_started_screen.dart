import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() =>
      _GetStartedScreenState();
}

class _GetStartedScreenState
    extends State<GetStartedScreen> {

  String? selectedOption;

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  void continueNext() {
    if (selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an option to continue.',
          ),
        ),
      );

      return;
    }

    // Later we can navigate to Login/Create Account
    // depending on the selected option.

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You selected: $selectedOption',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 15),

                // ==========================================
                // LOGO
                // ==========================================

                Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/heart.jpeg',

                      width: 80,
                      height: 80,

                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ==========================================
                // TITLE
                // ==========================================

                const Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'How would you like to participate\n'
                    'in the NeedMatch community?',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // ==========================================
                // I HAVE
                // ==========================================

                participationCard(
                  option: 'I Have',
                  title: 'I Have Something',
                  description:
                      'Share items, food, skills, services, '
                      'time or money with someone in need.',

                  icon: Icons.volunteer_activism_outlined,

                  color: const Color(0xFF168B45),
                ),

                const SizedBox(height: 16),

                // ==========================================
                // I NEED
                // ==========================================

                participationCard(
                  option: 'I Need',
                  title: 'I Need Something',
                  description:
                      'Find resources, food, services, '
                      'skills or support from the community.',

                  icon: Icons.search_outlined,

                  color: const Color(0xFF3F7FDB),
                ),

                const SizedBox(height: 16),

                // ==========================================
                // VOLUNTEER
                // ==========================================

                participationCard(
                  option: 'Volunteer',
                  title: 'I Want to Volunteer',
                  description:
                      'Offer your time, skills or help '
                      'with pickup, delivery and community work.',

                  icon: Icons.people_outline,

                  color: const Color(0xFFE89A20),
                ),

                const SizedBox(height: 16),

                // ==========================================
                // BOTH / EXPLORE
                // ==========================================

                participationCard(
                  option: 'Both',
                  title: 'I Want to Help & Receive',
                  description:
                      'Share resources while also finding '
                      'support for your own community needs.',

                  icon: Icons.sync_alt,

                  color: const Color(0xFF8A55C7),
                ),

                const SizedBox(height: 30),

                // ==========================================
                // CONTINUE BUTTON
                // ==========================================

                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed: continueNext,

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF168B45),

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'Continue',

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ==========================================
                // GUEST
                // ==========================================

                Center(
                  child: TextButton(
                    onPressed: () {
                      // Later navigate to Home
                    },

                    child: const Text(
                      'Continue as Guest',

                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // PARTICIPATION CARD
  // ======================================================

  Widget participationCard({
    required String option,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final bool selected =
        selectedOption == option;

    return GestureDetector(
      onTap: () {
        selectOption(option);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        width: double.infinity,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.08)
              : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: selected
                ? color
                : Colors.grey.shade300,

            width: selected ? 2 : 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center,

          children: [

            // ------------------------------------------
            // ICON
            // ------------------------------------------

            Container(
              width: 58,
              height: 58,

              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            // ------------------------------------------
            // TEXT
            // ------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? color
                          : const Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    description,

                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ------------------------------------------
            // SELECTION INDICATOR
            // ------------------------------------------

            Container(
              width: 24,
              height: 24,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: selected
                      ? color
                      : Colors.grey.shade400,
                  width: 2,
                ),

                color: selected
                    ? color
                    : Colors.transparent,
              ),

              child: selected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}