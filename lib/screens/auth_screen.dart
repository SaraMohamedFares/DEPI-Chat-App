import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' ;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return HomeScreen(user: snapshot.data!);
          }
          else{
            return FirebaseAuthWidget();

          }
        }
    );
  }
}

class FirebaseAuthWidget extends StatelessWidget {
  const FirebaseAuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider(),
        GoogleProvider(
            clientId: "814987418125-nfm0ns061i3gmurd4bui7ji0bufq83ib.apps.googleusercontent.com"
        ),
      ],
      actions: [
        AuthStateChangeAction<UserCreated>((context,state)async{
          // final user =FirebaseAuth.instance.currentUser;
          if(state.credential.user!=null){
            final chatUser=ChatUser(
                id:state.credential.user!.uid,
                email:state.credential.user!.email!,
                date: DateTime.now().toIso8601String(),);

            UserServices.addNewUser(chatUser);

          }
        })
      ],
      headerBuilder: (context,constraints,shrinkOffset){
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(Icons.chat_bubble,size: 100,color: Colors.deepPurple,),
              Text('Welcome To Flutter Chat App',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
        );
      },
      sideBuilder: (context,constraints){
        return Padding(
          padding: const EdgeInsets.all(8),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble,size: 100,color: Colors.deepPurple,),
              Text('Welcome To Flutter Chat App',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
        );
      },);
  }
}

class CustomLogin extends StatefulWidget {
  const CustomLogin({super.key});

  @override
  State<CustomLogin> createState() => _CustomLoginState();
}

class _CustomLoginState extends State<CustomLogin> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person,color: Colors.deepPurple,size: 100,),
                Text('Welcome To Chat App'),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailCtrl.text.trim(),
                        password: _passwordCtrl.text,
                      );
                    } on FirebaseAuthException catch (e) {
                      print(e.message);
                      setState(
                            () => errorMessage = _friendlyMessageFromCode(e.code),
                      );
                    } catch (e) {
                      setState(
                            () => errorMessage =
                        'Unexpected error. Please try later.',
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 12),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _friendlyMessageFromCode(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'The supplied auth credential is not valid.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Try again or reset your password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Sign in failed. Please try again.';
    }
  }
}

