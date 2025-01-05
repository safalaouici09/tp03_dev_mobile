import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizz_app/screens/quizz_page.dart';

class AvatarSelectionPage extends StatelessWidget {
  final List<String> avatarPublicIds = [
    'avatars/mharnk7eib1kmxptbvuv',
    'avatars/ur50fni4dnj0d6m5wonz',
    'avatars/lx8i8ajdvnyppykra9tz',
    'avatars/o34pukhais7xnmm8azxa',
    'avatars/xtlbxs22gvzm9cf3geac',
  ];

  final String cloudinaryBaseUrl =
      'https://res.cloudinary.com/dlpp5i2wa/image/upload/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Avatar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: avatarPublicIds.length,
                itemBuilder: (context, index) {
                  final avatarUrl =
                      '$cloudinaryBaseUrl${avatarPublicIds[index]}';
                  return GestureDetector(
                    onTap: () async {
                      await _selectAvatar(context, avatarUrl);
                    },
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(avatarUrl),
                        radius: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAvatar(BuildContext context, String avatarUrl) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update user's photoURL in Firebase Authentication
        await user.updatePhotoURL(avatarUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar selected successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizzPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting avatar: $e')),
      );
    }
  }
}
