import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RegistrationScreen(),
        '/play': (context) => PlayScreen(),
      },
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedGrade;
  String? _selectedMembership;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String grade = _selectedGrade ?? 'Not selected';
      String membership = _selectedMembership ?? 'Not selected';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Name: $name\nGrade: $grade\nMembership: $membership')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check screen width; set field width to 600px if wider than 800px, otherwise adaptive
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = screenWidth > 800 ? 600.0 : screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Player'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Register'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Play'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/play');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name Field
                Text(
                  'Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: fieldWidth,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Grade Dropdown
                Text(
                  'Grade',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: fieldWidth,
                  child: DropdownButtonFormField<String>(
                    value: _selectedGrade,
                    items: ['A+', 'A-', 'B+', 'B-', 'C+', 'C-']
                        .map((grade) => DropdownMenuItem(
                              value: grade,
                              child: Text(grade),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGrade = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a grade' : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Membership Dropdown
                Text(
                  'Membership',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: fieldWidth,
                  child: DropdownButtonFormField<String>(
                    value: _selectedMembership,
                    items: ['Guest', 'Member']
                        .map((membership) => DropdownMenuItem(
                              value: membership,
                              child: Text(membership),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMembership = value;
                      });
                    },
                    validator: (value) => value == null
                        ? 'Please select a membership type'
                        : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Register Button
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    minimumSize: Size(150, 50),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Register'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Play'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/play');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Play Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
