import 'package:flutter/material.dart';
import 'users_api.dart'; // Ensure this file is implemented and contains getUserByUsername

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Developer Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Search for GitHub Developers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final usersApi = UsersApi();

  bool isLoading = false;
  bool showResults = false;
  String? errorMessage;

  Map<String, dynamic> mockUser = {};

  void handleSearchUser() async {
    final username = _searchController.text.trim();
    if (username.isEmpty) return;

    setState(() {
      isLoading = true;
      showResults = false;
      errorMessage = null;
    });

    try {
      var user = await usersApi.getUserByUsername(username);
      setState(() {
        mockUser = user;
        showResults = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Could not fetch user: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(mockUser['avatar_url'] ?? ''),
                radius: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mockUser['login'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    if (mockUser['bio'] != null)
                      Text(
                        mockUser['bio'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (mockUser['location'] != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            mockUser['location'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Chip(label: Text("Followers: ${mockUser['followers'] ?? 0}")),
              Chip(label: Text("Following: ${mockUser['following'] ?? 0}")),
              Chip(label: Text("Repos: ${mockUser['public_repos'] ?? 0}")),
            ],
          ),
          const SizedBox(height: 16),

          // Skills Section
          if ((mockUser['languages'] ?? []).isNotEmpty) ...[
            const Text(
              "Skills",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: List<Widget>.from(
                (mockUser['languages'] ?? []).map(
                  (lang) => Chip(
                    label: Text(lang),
                    backgroundColor: Colors.deepPurple.shade50,
                    labelStyle: const TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Repositories
          if ((mockUser['repositories'] ?? []).isNotEmpty) ...[
            const Text(
              "Repositories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
              children: List<Widget>.from(
                (mockUser['repositories'] ?? []).map(
                  (repo) => ListTile(
                    leading: const Icon(
                      Icons.folder_open,
                      color: Colors.deepPurple,
                    ),
                    title: Text(repo),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Image.asset('assets/images/icons8-github-120.png', height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Whom are you planning to hire?",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.deepPurple,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: handleSearchUser,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (showResults && mockUser.isNotEmpty) buildUserCard(),
          ],
        ),
      ),
    );
  }
}