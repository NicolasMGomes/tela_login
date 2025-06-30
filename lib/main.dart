import 'package:flutter/material.dart';

/// A custom painter for drawing a checkerboard pattern on the canvas.
class CheckerboardPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final double squareSize;

  /// Creates a [CheckerboardPainter].
  ///
  /// The [color1] and [color2] define the two alternating colors of the squares.
  /// The [squareSize] determines the size of each square in logical pixels.
  CheckerboardPainter({
    required this.color1,
    required this.color2,
    this.squareSize = 64.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()..color = color1;
    final Paint paint2 = Paint()..color = color2;

    // Calculate the number of columns and rows needed to cover the entire size.
    final int numColumns = (size.width / squareSize).ceil();
    final int numRows = (size.height / squareSize).ceil();

    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numColumns; j++) {
        final Rect rect = Rect.fromLTWH(
          j * squareSize,
          i * squareSize,
          squareSize,
          squareSize,
        );
        // Alternate colors based on the sum of row and column indices.
        final Paint currentPaint = (i + j) % 2 == 0 ? paint1 : paint2;
        canvas.drawRect(rect, currentPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Only repaint if the colors or square size have changed.
    if (oldDelegate is CheckerboardPainter) {
      return oldDelegate.color1 != color1 ||
          oldDelegate.color2 != color2 ||
          oldDelegate.squareSize != squareSize;
    }
    return true;
  }
}

/// A reusable widget for creating styled text input fields.
class StyledTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;

  /// Creates a [StyledTextField].
  ///
  /// [labelText] is the text displayed above the input field.
  /// [controller] is the [TextEditingController] to manage the input text.
  /// [obscureText] is true if the text should be hidden (e.g., for passwords).
  const StyledTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 40.0, bottom: 8.0),
          child: Text(
            labelText,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB), // Light off-white background
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: const InputDecoration(
              border: InputBorder.none, // Remove default border
              contentPadding: EdgeInsets.symmetric(vertical: 14.0),
            ),
          ),
        ),
      ],
    );
  }
}

/// A reusable widget for creating styled buttons.
class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  /// Creates a [StyledButton].
  ///
  /// [text] is the label displayed on the button.
  /// [onPressed] is the callback function executed when the button is pressed.
  const StyledButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      width: double.infinity, // Full width
      height: 60.0, // Fixed height
      decoration: BoxDecoration(
        color: const Color(0xFFBFBCA2), // Button background color
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// A screen displayed after a successful login.
class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background checkerboard pattern
          CustomPaint(
            painter: CheckerboardPainter(
              color1: const Color(0xFFF9E8D1),
              color2: const Color(0xFFEBCDA6),
            ),
            child: Container(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.check_circle_outline,
                    size: 80, color: Colors.green),
                const SizedBox(height: 20),
                const Text(
                  'Login efetuado com sucesso!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                StyledButton(
                  text: 'Voltar ao Login',
                  onPressed: () {
                    // Pop all routes until the first route (LoginScreen)
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A screen for user registration.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(color: Colors.black), // Back button color
        // Extend body behind app bar so the background painter covers the whole screen
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          // Background checkerboard pattern
          CustomPaint(
            painter: CheckerboardPainter(
              color1: const Color(0xFFF9E8D1),
              color2: const Color(0xFFEBCDA6),
            ),
            child: Container(),
          ),
          SingleChildScrollView(
            child: Padding(
              // Add top padding to move content below the AppBar
              padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StyledTextField(
                    labelText: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20.0),
                  StyledTextField(
                    labelText: 'Senha',
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20.0),
                  StyledTextField(
                    labelText: 'Confirmar Senha',
                    controller: _confirmPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 40.0),
                  StyledButton(
                    text: 'Efetuar Cadastro',
                    onPressed: () {
                      // Placeholder for registration logic
                      Navigator.pop(context); // Go back to the login screen
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The initial login screen of the application.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background checkerboard pattern
          CustomPaint(
            painter: CheckerboardPainter(
              color1: const Color(0xFFF9E8D1),
              color2: const Color(0xFFEBCDA6),
            ),
            child: Container(),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 80.0), // Top padding for logo placement
                // Nintendo 64 logo from a network URL
                Image.network(
                  'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 60.0), // Space after logo
                StyledTextField(
                  labelText: 'Email',
                  controller: _emailController,
                ),
                const SizedBox(height: 20.0),
                StyledTextField(
                  labelText: 'Senha',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 40.0), // Space before buttons
                StyledButton(
                  text: 'Login',
                  onPressed: () {
                    // Navigate to success screen upon login attempt
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                        const LoginSuccessScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                StyledButton(
                  text: 'Cadastrar',
                  onPressed: () {
                    // Navigate to registration screen
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                        const RegistrationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40.0), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N64 Login',
      debugShowCheckedModeBanner: false, // Hide debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}

void main() {
  runApp(const MyApp());
}