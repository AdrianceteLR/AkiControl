import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          backgroundColor: const Color(0xFFFFF5EE),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_headerDrawer(context), const MenuDrawer()],
            ),
          )),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Stack(
        children: [
          HomeBackground(),
          Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Material _headerDrawer(BuildContext context) {
    return Material(
      color: const Color(0xFFE76F51),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, bottom: 25),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/ic_launcher.png'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 10),
              Text(
                'AkiControl',
                style: TextStyle(fontSize: 30, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
