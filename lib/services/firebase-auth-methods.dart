import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idiom_journey/screens/home-screen.dart';
import 'package:idiom_journey/utils/showSnackBar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String ime,
    required String telefon,
    required BuildContext context,
  }) async {
    if (email.isEmpty) {
      showSnackBar(context, 'Polje za email ne smije biti prazno.');
      return;
    }

    if (password.isEmpty) {
      showSnackBar(context, 'Polje za lozinku ne smije biti prazno.');
      return;
    }

    try {
      // Registracija korisnika
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

   
      String uid = userCredential.user!.uid;

      // cuavnje korisnika u Firestore
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'email': email,
        'fullName': ime,
        'phoneNumber': telefon,
        'lessonsNumber': 0,
        'testsNumber': 0,
        'dailyActivity': [],
        'dayStreak': 0,
      });

      showSnackBar(context, 'Uspešno ste registrovani!');
    } on FirebaseAuthException catch (e) {
      String message = 'Došlo je do greške. Pokušajte ponovo.';

      switch (e.code) {
        case 'invalid-email':
          message = 'Unesena je neispravna email adresa.';
          break;
        case 'weak-password':
          message = 'Lozinka je previše slaba. Pokušajte sa jačom lozinkom.';
          break;
        case 'email-already-in-use':
          message = 'Email adresa je već u upotrebi.';
          break;
        case 'operation-not-allowed':
          message = 'Registracija sa emailom trenutno nije omogućena.';
          break;
        case 'network-request-failed':
          message = 'Provjerite svoju internet konekciju.';
          break;
        default:
          message = e.message ?? 'Došlo je do nepoznate greške.';
      }

      showSnackBar(context, message);
    }
  }

//EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isEmpty) {
      showSnackBar(context, 'Polje za email ne smije biti prazno.');
      return;
    }

    if (password.isEmpty) {
      showSnackBar(context, 'Polje za lozinku ne smije biti prazno.');
      return;
    }
    try {
      // Prijava korisnika
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );


      String uid = userCredential.user!.uid;

      // uzimanje podataka iz Firestore-a
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        //  podaci korisnikaiz Firestore-a
      } else {
        showSnackBar(context, 'Nema podataka za ovog korisnika.');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Došlo je do greške. Pokušajte ponovo.';

      switch (e.code) {
        case 'invalid-email':
          message = 'Unesena je neispravna email adresa.';
          break;
        case 'invalid-credential': 
          message = 'Uneseni podaci za prijavu su neispravni ili su istekli.';
          break;
        case 'user-not-found': 
          message = 'Korisnik sa unesenom email adresom ne postoji.';
          break;
        case 'wrong-password': 
          message = 'Unesena lozinka nije ispravna.';
          break;
        case 'user-disabled':
          message = 'Ovaj korisnički nalog je onemogućen.';
          break;
        case 'operation-not-allowed':
          message = 'Registracija sa emailom trenutno nije omogućena.';
          break;
        case 'network-request-failed':
          message = 'Proverite svoju internet konekciju.';
          break;
        default:
          message = e.message ?? 'Došlo je do nepoznate greške.';
      }

      showSnackBar(context, message);
    }
  }
}
