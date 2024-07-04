import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/app/provider/auth_bloc.dart';
import 'package:myapp/app/provider/profile/profile_bloc.dart';
import 'package:myapp/app/provider/profile/profile_event.dart';
import 'package:myapp/app/models/profile.dart';

class ProfileVerificationStepper extends StatefulWidget {
  final int userId;

  ProfileVerificationStepper({required this.userId});

  @override
  _ProfileVerificationStepperState createState() => _ProfileVerificationStepperState();
}

class _ProfileVerificationStepperState extends State<ProfileVerificationStepper> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verifikasi data'),
          content: Text('User ini harus diverifikasi oleh atasan.'),
          actions: <Widget>[
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: () {
        if (_currentStep == 0) {
          if (_formKey.currentState!.validate()) {
            final profile = Profile(
              userId: widget.userId,
              username: _nameController.text,
              alamat: _emailController.text,
              nomer_telepon: _phoneController.text,
            );

            print('Profile: ${profile.toJson()}'); // Add logging here

            context.read<ProfileBloc>().add(CreateProfile(profile));

            setState(() {
              _currentStep += 1;
            });
          } else {
            print('Form validation failed'); // Add logging here
          }
        } else if (_currentStep == 1) {
          _showVerificationDialog(context);
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep -= 1;
          });
        }
      },
      steps: [
        Step(
          title: Text('Isi Profile'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your alamat';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Verifikasi Data'),
          content: Text('User ini harus diverifikasi oleh atasan.'),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
      ],
    );
  }
}
