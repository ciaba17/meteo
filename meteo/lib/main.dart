import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(EcoWeatherApp());
}

class EcoWeatherApp extends StatelessWidget {
  const EcoWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Appbar per logo e tasto menu
      appBar: AppBar(
      // Logo EcoWeather
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Icon(Icons.eco, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text("EcoWeather",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800]
              )
            )
          ]
        ),
      ),
      // Menu laterale
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.eco, color: Colors.greenAccent, size: 28),
                  Text("EcoWeather",
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Info"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Impostazioni"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => mostaDettagliMeteo(context),
                // Nome città e data a sinistra e simbolo Weather
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Roma",
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                        Text("24 aprile",
                          style: TextStyle(fontSize: 20, color: Colors.grey[700])),
                        Text("20°",
                          style:TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.wb_cloudy, size: 72, color: Colors.grey[700])
                  ],
                ),
              ),
                  // Caselle con le previsioni successive
              SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    forecastCard("Gio", Icons.cloud, "18°"),
                    forecastCard("Ven", Icons.cloud, "20°"),
                    forecastCard("Sab", Icons.wb_sunny, "22°"),
                    forecastCard("Dom", Icons.wb_sunny_outlined, "21°"),
                  ],
                ),

                SizedBox(height: 50),
                
                // giudizio ambientale
                Center(
                  child: Column(
                    children: [
                      Text("BILANCIO AMBIENTALE",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      
                      SizedBox(height: 25),
                
                      // Faccina
                      CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.sentiment_satisfied_alt_outlined,
                          size: 70, color: Colors.black),
                      ),
                
                        SizedBox(height: 20),
                
                        // Bottone
                        OutlinedButton(
                          onPressed: () => mostraInquinamento(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 2),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child : Text(
                            "APPROFONDISCI",
                            style: TextStyle(fontSize: 16),
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
        ),
      );
  }

  Widget forecastCard(String day, IconData icon, String temp) {
    return Column(
      children: [
        Text(day,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Icon(icon, size: 32, color: Colors.grey[700]),
        SizedBox(height: 4),
        Text(temp, style: TextStyle(fontSize: 16))
      ],
    );
  }

  void mostraInquinamento(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        reverseTransitionDuration: Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => InquinamentoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: Offset(0.0, 1.0), // da sotto verso il centro
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
  
  void mostaDettagliMeteo(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 200),
        reverseTransitionDuration: Duration(milliseconds: 100),
        pageBuilder: (context, animation, secondaryAnimation) => DettagliMeteoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final scaleTween = Tween<double>(
            begin: 0.7, // da sotto verso il centro
            end:1.0,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          );
        },
      ),
    );
  }
}


class InquinamentoScreen extends StatelessWidget {
  const InquinamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dettagli"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            infoBullet("Dettaglio 1", Icons.check, Colors.green),
            infoBullet("Dettaglio 2", Icons.warning, Colors.red),
            infoBullet("Dettaglio 3", Icons.warning, Colors.red),
            infoBullet("Dettaglio 4", Icons.warning, Colors.red),
          ],
        ),
      ),
    );
  }


  Widget infoBullet(String text, IconData iconData, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(iconData, color: color, size: 30),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)),
        ],
      ),
    );
  }
}


class DettagliMeteoScreen extends StatelessWidget {
  const DettagliMeteoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dettagli"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            infoBullet("Dettaglio Meteo", Icons.check, Colors.green),

          ],
        ),
      ),
    );
  }


  Widget infoBullet(String text, IconData iconData, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(iconData, color: color, size: 30),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)),
        ],
      ),
    );
  }
}