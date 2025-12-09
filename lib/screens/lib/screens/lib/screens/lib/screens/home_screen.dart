import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? prayerTimes;
  int totalPoints = 0;  // From Firebase later

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final response = await http.get(
      Uri.parse('http://api.aladhan.com/v1/timingsByCity?city=Delhi&country=India&method=2'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        prayerTimes = data['data']['timings'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salaah Streak'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              // Leaderboard screen later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leaderboard Coming Soon!')),
              );
            },
          ),
        ],
      ),
      body: prayerTimes == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Total Hasanaat Points'),
                    trailing: Text('$totalPoints', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                _buildPrayerTile('Fajr', prayerTimes!['Fajr']),
                _buildPrayerTile('Zuhr', prayerTimes!['Dhuhr']),
                _buildPrayerTile('Asr', prayerTimes!['Asr']),
                _buildPrayerTile('Maghrib', prayerTimes!['Maghrib']),
                _buildPrayerTile('Isha', prayerTimes!['Isha']),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            totalPoints += 100;  // Dummy points for now
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Namaz Completed! +100 Points')),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildPrayerTile(String name, String time) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.access_time, color: Colors.green),
        title: Text(name),
        trailing: Text(time),
        onTap: () {
          // Mark as completed
        },
      ),
    );
  }
}