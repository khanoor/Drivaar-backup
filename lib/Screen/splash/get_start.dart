import 'package:drivaar/Screen/authentication/login_register.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';

class GetStart extends StatefulWidget {
  const GetStart({Key? key}) : super(key: key);

  @override
  State<GetStart> createState() => _GetStartState();
}

class _GetStartState extends State<GetStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/driver1.gif'), fit: BoxFit.cover),
            color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // const Image(
            //   image: AssetImage('images/driver1.gif'),
            //   fit: BoxFit.cover,
            // ),
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginRegister()));
                },
                child: Container(
                  width: 240,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: app_color),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Get Started",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: app_color,
                                size: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
