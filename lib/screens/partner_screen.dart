import 'package:flutter/material.dart';

// Third Party Pacakages
import 'package:provider/provider.dart';

// Provider Imports
import '../providers/partner.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Become Partner'),
          onPressed: () async {
            await Provider.of<Partner>(context).becomePartner();
          },
        ),
      ),
    );
  }
}
