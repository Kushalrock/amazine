import 'package:flutter/material.dart';

// Third Party Pacakages
import 'package:provider/provider.dart';

// Provider Imports
import '../providers/partner.dart';

class PartnerScreen extends StatefulWidget {
  @override
  _PartnerScreenState createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  bool _checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.arrow_downward,
        ),
        backgroundColor: Colors.white70,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Welcome to Amazine Corp. By becoming a partner you are agreeing to the conditions listed below in all your proper senses. These conditions are generated by electronic devices and would need no physical signatures from your end. Please read them carefully.',
              softWrap: true,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Text(
                'Electronic Communication',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'If you are communicating with us electronically. You consent to receive communications from us electronically. We will communicate with you by e-mail or by posting notices on this Site. You agree that all agreements, notices, disclosures and other communications that we provide to you electronically satisfy any legal requirement that such communications be in writing.',
              softWrap: true,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Text(
                'Copyright notice',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              ' All content included on this App, such as text, graphics, logos, button icons, images, audio clips, digital downloads, data compilations, and software, is the property of Amazine, the respective owner and its affiliates ',
              softWrap: true,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Text(
                'General',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'You understand that you, and not Amazine, are responsible for all electronic communications and content sent from your computer to us and you must use the Site for lawful purposes only and only in accordance with the applicable law. You must not use the App for any of the following: for fraudulent purposes, or in connection with a criminal offence or other unlawful activity to send, use or reuse any material that is illegal, offensive, (including but not limited to material that is sexually explicit or which promotes racism, bigotry, hatred or physical harm), abusive, harassing, misleading, indecent, defamatory, disparaging, obscene or menacing; or in breach of copyright, trademark, confidentiality, privacy or any other proprietary information or right; or is otherwise injurious to third parties; or objectionable or otherwise unlawful in any manner whatsoever; or which consists of or contains software viruses, political campaigning, commercial solicitation, chain letters, mass mailings or any “spam”; to cause annoyance, inconvenience or needless anxiety;',
              softWrap: true,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Applicable Law: By visiting this App, you agree that the laws of India will govern these Terms of Use and any dispute of any sort that might arise between you and Amazine or its affiliates',
              softWrap: true,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Disputes Any dispute relating in any way to your visit to this Site shall be submitted to the exclusive jurisdiction of the local courts.',
              softWrap: true,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            CheckboxListTile(
              title: Text(
                'I agree to all the above Amazine T&Cs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: _checkboxValue,
              onChanged: (newValue) {
                setState(() {
                  _checkboxValue = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            RaisedButton(
              child: Text('Become Partner'),
              onPressed: _checkboxValue == false
                  ? null
                  : () async {
                      await Provider.of<Partner>(context, listen: false)
                          .becomePartner();
                    },
            ),
          ],
        ),
      ),
    );
  }
}
