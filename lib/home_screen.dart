import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:omvad/screens/workout_detail_screen.dart';
import 'package:omvad/screens/history_screen.dart'; // 👈 Make sure this import is correct
// import 'package:omvad/screens/profile_screen.dart'; // 👈 Replace or create a placeholder

class HomeScreen extends StatefulWidget {
  final dynamic user;
  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeContent(context),
      const HistoryScreen(),
      // const ProfileScreen(), // 👈 Replace with your actual Profile UI
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.network(
              'https://images.pexels.com/photos/1229356/pexels-photo-1229356.jpeg?cs=srgb&dl=pexels-anush-1229356.jpg&fm=jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.center,
              child: const Text(
                'Welcome Back, Athlete!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: const [
              Text(
                'Workouts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                'See All',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildWorkoutCard(
                title: 'Full Body Workout',
                imageUrl:
                    'https://plus.unsplash.com/premium_photo-1661265933107-85a5dbd815af?fm=jpg&q=60&w=3000',
                context: context,
                workoutType: 'Full Body Workout',
              ),
              const SizedBox(height: 10),
              _buildWorkoutCard(
                title: 'Cardio Blast',
                imageUrl:
                    'https://www.shutterstock.com/image-photo/caucasian-young-active-handsome-sportsman-600nw-2006269940.jpg',
                context: context,
                workoutType: 'Cardio Blast',
              ),
              const SizedBox(height: 10),
              _buildWorkoutCard(
                title: 'Strength Training',
                imageUrl:
                    'https://static.toiimg.com/thumb/imgsize-955704,msid-70364339/70364339.jpg?width=500&resizemode=4',
                context: context,
                workoutType: 'Strength Training',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard({
    required String title,
    required String imageUrl,
    required BuildContext context,
    required String workoutType,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutDetailScreen(
            workoutType: workoutType,
            workoutTitle: title,
            exercises: ['Jumping Jacks', 'Push Ups', 'Squats', 'Plank'],
          ),
        ),
      ),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
