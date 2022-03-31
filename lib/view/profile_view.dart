import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_login/services/authentication.dart';
import 'package:google_login/utils/colors.dart';
import 'package:google_login/view/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: appBar(),
        centerTitle: true,
      ),
      body: body(),
    );
  }

  Widget appBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/firebase_logo.png',
          height: 20,
        ),
        SizedBox(width: 8),
        Text(
          'FlutterFire',
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 18,
          ),
        ),
        Text(
          ' Authentication',
          style: TextStyle(
            color: CustomColors.firebaseOrange,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget body() {
    return SafeArea(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          bottom: 20.0,
        ),
        child: userHandler(),
      ),
    );
  }

  // BODY METHOD

  Widget userHandler() {
    if (_user.isAnonymous) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          anonimousHandler(),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          photoHandler(),
          SizedBox(height: 32.0),
          nameHandler(),
          SizedBox(height: 16.0),
          emailHandler(),
          SizedBox(height: 16.0),
          phoneHandler(),
          SizedBox(height: 48.0),
          logoutHandler(),
        ],
      );
    }
  }

  // LOGIN/LOGOUT METHODS

  Widget logoutHandler() {
    if (_isSigningOut) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.redAccent,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isSigningOut = true;
          });
          await Authentication.signOut(context: context);
          setState(() {
            _isSigningOut = false;
          });
          Navigator.of(context).pushReplacement(_routeToSignInScreen());
        },
        child: Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }
  }

  Widget anonimousHandler() {
    return Text(
      "Usuario anonimo não tem permissão para mostrar foto, telefone, email, entre outros.",
      style: TextStyle(
        color: CustomColors.firebaseGrey,
        fontSize: 26,
      ),
    );
  }

  Widget photoHandler() {
    if (_user.photoURL != null) {
      return ClipOval(
        child: Material(
          color: CustomColors.firebaseGrey.withOpacity(0.3),
          child: Image.network(
            _user.photoURL!,
            fit: BoxFit.fitHeight,
          ),
        ),
      );
    } else {
      return ClipOval(
        child: Material(
          color: CustomColors.firebaseGrey.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.person,
              size: 60,
              color: CustomColors.firebaseGrey,
            ),
          ),
        ),
      );
    }
  }

  Widget nameHandler() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Ola, ",
          style: TextStyle(
            color: CustomColors.firebaseGrey,
            fontSize: 26,
          ),
        ),
        Text(
          _user.displayName!,
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 26,
          ),
        ),
      ],
    );
  }

  Widget phoneHandler() {
    if (_user.phoneNumber == null) {
      return Text(
        "Telefone não autorizado",
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      );
    } else {
      return Text(
        "Telefone: ${_user.phoneNumber}",
        style: TextStyle(color: Colors.green),
      );
    }
  }

  Widget emailHandler() {
    if (_user.email == null) {
      return Text(
        "Email não especificado",
        style: TextStyle(
          color: CustomColors.firebaseYellow,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _user.email!,
            style: TextStyle(color: CustomColors.firebaseOrange),
          ),
          SizedBox(height: 16.0),
          Text(
            (_user.emailVerified == true
                ? " (Email verificado)"
                : " (Email não verificado)"),
            style: TextStyle(
                color: _user.emailVerified ? Colors.green : Colors.red),
          ),
        ],
      );
    }
  }
}
