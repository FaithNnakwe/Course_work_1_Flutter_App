import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter & Image Toggle App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _counter = 0; // creates the counter variables to keep track.
  bool _showFirstImage = true; // boolean to track the current image state.
  late AnimationController _controller; // Manages the animation's duration.
  late Animation<double> _fadeAnimation; // fades the image out based on the animation's value which is 1.

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // sets the animation fade-in value to 1.
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation( // Provides a smoother image transition.
      parent: _controller,
      curve: Curves.easeInOut,
    );
    // Starts the animation initially
    _controller.forward();
  }

  void _incrementCounter() {
    setState(() {
      _counter++; // increments the counter when the button is pressed.
    });
  }

  void _toggleImage() { // Method to toggle the image and start the animation.
    setState(() {
      _showFirstImage = !_showFirstImage;
      _controller.forward(from: 0.0);
    });
  }

  void _reset() async { // Functionality to reset the counter and image back to their intial states.
    bool? confirmReset = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'), // Confirmation dialog box before resetting.
          content: const Text('Are you sure you want to reset the counter and image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'), // Incase of accidential resets.
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'), // Confirm the reset.
            ),
          ],
        );
      },
    );

    if (confirmReset == true) { // Boolean expression to confirm reset.
      setState(() {
        _counter = 0; // If true, the counter is reset back to 0
        _showFirstImage = true; // The first image is shown.

        _controller.forward(from:0.0); // Animates the reset image fade-in.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                _showFirstImage ? 'assets/image1.jpg' : 'assets/image2.jpg',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton( // Elevated button for the image widget.
              onPressed: _toggleImage, //  onPressed event handler for the button to toggle between the two images
              child: const Text('Toggle Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _incrementCounter, // onPressed event handler for the button to increment the counter.
              child: const Text('Increment Counter'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _reset, // event handler for the reset button to reset the counter variable and toggle the image back to its original state.
              child: const Text('Reset',
              style: TextStyle(color:Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Stops the controller and releases resources so as to remove memory leak.
    super.dispose(); // Ensures that the parent class is cleaned up.
  }
}
