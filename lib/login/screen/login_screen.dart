import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/home/bloc/music_bloc.dart';
import 'package:music_player/home/repo/music_repo.dart';
import 'package:music_player/home/screen/home_screen.dart';
import 'package:music_player/utils/widgets/custom_text_feild.dart';
import 'package:music_player/utils/widgets/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late AnimationController _controller;
  late Animation<double> _handleAnimation;
  late Animation<double> _discAnimation;
  final TextEditingController _emailId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  List<int>? favId = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _handleAnimation = Tween<double>(begin: 0, end: -90).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.5, curve: Curves.easeInOut)),
    );
    _discAnimation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1, curve: Curves.easeInOut)),
    );
    prefsFetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> prefsFetchData() async {
    final SharedPreferences prefs = await _prefs;
    favId = prefs.getStringList("favId")?.map((e) => int.parse(e)).toList();
  }

  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 280, top: 70),
                    child: Align(
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _handleAnimation.value * (3.14159 / 500),
                            origin: const Offset(0.0, 1.0),
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                _controller.reset();
                                _controller.forward();
                              },
                              child: Image.asset("assets/image/handle.png", width: 200, height: 200),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _discAnimation.value * (3.14159 / 180), // Convert to radians
                          child: Image.asset("assets/image/disc.png", width: 250, height: 250),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomTextFormField(controller: _emailId, hintText: "Email", prefixIcon: Icons.email),
              const SizedBox(height: 20),
              CustomTextFormField(controller: _password, hintText: "Password", prefixIcon: Icons.lock, obscureText: true),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () async {
                        if(_emailId.text.isEmpty){
                          showCustomSnackBar(context, "Enter Email Id.");
                        } else if(_password.text.isEmpty){
                          showCustomSnackBar(context, "Enter Password.");
                        } else if(!Validator.validateEmail(_emailId.text.trim())){
                          showCustomSnackBar(context, "Invalid Email Id.");
                        } else {
                          login();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "Login",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    _controller.reset();
    _controller.forward();
    List fav = [];
    Future.delayed(const Duration(seconds: 3), () async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('emailid', isEqualTo: _emailId.text.trim())
          .get();
      if(querySnapshot.docs.isNotEmpty){
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        fav = userDoc['fav'] ?? [];
        List newfav = Set<int>.from(favId??[]).union(Set<int>.from(fav)).toList();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userDoc.id)
            .update({'fav': newfav});
        fav = newfav;
      } else {
        CollectionReference users = FirebaseFirestore.instance.collection('user');
        users.add({
          'emailid': _emailId.text.trim(),
          'fav': [],
          'password': _password.text.trim(),
        }).then((value) => print("User added"))
          .catchError((error) => print("Failed to add user: $error"));
      }
      _controller.stop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BlocProvider<MusicBloc>(
        create: (context) => MusicBloc(musicRepository: MusicRepositoryImpl()),
          child: HomeScreen(emailId: _emailId.text.trim(), fav: fav,
          )
        )
       )
      );
    });
  }
}