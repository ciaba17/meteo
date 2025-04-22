import 'package:flutter/material.dart';

void main() {
  runApp(EcoMeteoApp());
}

class EcoMeteoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,

      // Appbar per logo e tasto menu
      appBar: AppBar(
      // Logo EcoMeteo
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Icon(Icons.eco, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text("EcoMeteo",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800]))
          ],
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
                  Text("EcoMeteo",
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
              // Nome città e data a sinistra e simbolo meteo
              Text("Roma",
                  style:
                      TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text("24 aprile",
                  style: TextStyle(fontSize: 20, color: Colors.grey[700])),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("20°",
                      style:
                          TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
                  Icon(Icons.wb_cloudy, size: 72, color: Colors.grey[700])
                ],
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
              Text("GIUDIZIO",
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.sentiment_satisfied_alt,
                        size: 48, color: Colors.black),
                  ),
                  SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoBullet("> QUALITÀ ARIA"),
                      infoBullet("> RISCALDAMENTO GLOBALE"),
                      infoBullet("> ALTRO"),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text("75%",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              )
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

  Widget infoBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  void apriMenu() {
  }
}