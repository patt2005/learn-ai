import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:in_app_review/in_app_review.dart';
import 'package:lingo_ai_app/utils/colors.dart';
import 'package:lingo_ai_app/utils/consts.dart';
import 'package:lingo_ai_app/utils/game_provider.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // void _showContactDialog(BuildContext context) async {
  //   const email = "leahreyestr@gmx.com";
  //   final Uri emailUri = Uri(
  //     scheme: 'mailto',
  //     path: email,
  //     query: Uri.encodeQueryComponent('subject=Support Inquiry'),
  //   );

  //   try {
  //     await launchUrl(emailUri);
  //   } catch (e) {
  //     showCupertinoDialog(
  //       context: context,
  //       builder: (context) => CupertinoAlertDialog(
  //         title: const Text("Error"),
  //         content: const Text("No email client found on this device."),
  //         actions: [
  //           CupertinoDialogAction(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text("Close"),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  Future<void> showResetProgressConfirmationDialog(BuildContext context) async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Resetați progresul"),
          content: const Text(
            "Sunteți sigur că doriți să resetați progresul? Această acțiune nu poate fi anulată.",
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Anulare"),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                final provider =
                    Provider.of<GameProvider>(context, listen: false);
                await provider.resetProgress();
                Navigator.of(context).pop();
              },
              child: const Text("Confirmare"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenSize.height * 0.08),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Positioned(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenSize.height * 0.055),
                      const Text(
                        "Setări",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenSize.height * 0.06),
            ListTile(
              onTap: () async {
                await showResetProgressConfirmationDialog(context);
              },
              trailing: const Icon(
                CupertinoIcons.forward,
                color: Colors.red,
              ),
              leading: const Icon(
                CupertinoIcons.delete,
                color: Colors.red,
                size: 30,
              ),
              title: const Text(
                "Resetează progresul",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
