import 'package:flutter/material.dart';
import 'dart:convert'; // per jsonDecode
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';// per i grafici

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

      body: SingleChildScrollView(
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

  // PARTE PER API, DA AGGIUNGERE LA KEY
  Future<double> fetchTemperature(String cityName) async {
  final apiKey = 'LA_TUA_API_KEY'; // << qui metti la tua vera chiave
  final url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    double temp = data['main']['temp'].toDouble();
    return temp;
  } else {
    throw Exception('Errore nel caricamento dei dati meteo');
  }
}
}


class InquinamentoScreen extends StatelessWidget {
  const InquinamentoScreen({super.key});

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
                  Text("Dettagli",
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

      //Elenco Parametri
      body: SingleChildScrollView( // per lo scorrimento
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 5),

              Text("QUALITÀ DELL'ARIA",
                  style:
                      TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 100, 255))
              ),

              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoBullet("AQI: 85 ", Icons.speed, Colors.orange, "L’Indice di Qualità dell’Aria (AQI) valuta quanto l’aria è salubre, combinando diversi inquinanti in un unico valore.", context),
                      infoBullet("PM 2.5: 35µg/m³ ", Icons.blur_on, Colors.redAccent, "Micropolveri con diametro inferiore a 2.5 µm: penetrano nei polmoni e possono entrare nel sangue, causando seri danni alla salute.", context),
                      infoBullet("PM 10: 60µg/m³ ", Icons.blur_on, Colors.deepOrange, "Particelle sospese con diametro inferiore a 10 µm: possono essere inalate e causare problemi respiratori e infiammazioni.", context),
                      infoBullet("NO2: 45µg/m³ ", Icons.science, Colors.amber, "Il biossido di azoto è un gas irritante prodotto soprattutto dai veicoli a motore e può peggiorare l’asma e altre malattie respiratorie.", context),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoBullet("O3: 70µg/m³ ", Icons.cloud, Colors.lightBlue, "L’ozono troposferico si forma nell’atmosfera e può causare irritazioni a occhi e polmoni, soprattutto nelle giornate calde e soleggiate.", context),
                      infoBullet("CO: 0.7 mg/m³ ", Icons.local_fire_department, Colors.grey, "Il monossido di carbonio è un gas inodore e pericoloso prodotto dalla combustione incompleta, che riduce l’ossigeno trasportato nel sangue.", context),
                      infoBullet("SO2: 10µg/m³ ", Icons.science, Colors.purple, "Il biossido di zolfo proviene soprattutto da centrali a carbone e attività industriali, ed è dannoso per il sistema respiratorio.", context),
                      infoBullet("NH3: 15µg/m³ ", Icons.science, Colors.teal, "L’ammoniaca è rilasciata principalmente dall’agricoltura e può contribuire alla formazione di particolato fine nell’aria.", context),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 40),

              Text("EMISSIONI DI CO2",
                  style:
                      TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 0, 0))
              ),

              SizedBox(height: 20),

              SizedBox(
                height: 350,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 45,
                        color: Colors.red,
                        title: 'Trasporti\n45%',
                        radius: 160,
                        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      PieChartSectionData(
                        value: 30,
                        color: Colors.orange,
                        title: 'Industria\n30%',
                        radius: 160,
                        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      PieChartSectionData(
                        value: 15,
                        color: Colors.green,
                        title: 'Edifici\n15%',
                        radius: 160,
                        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      PieChartSectionData(
                        value: 10,
                        color: Colors.blue,
                        title: 'Agricoltura\n10%',
                        radius: 160,
                        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                    sectionsSpace: 0, //distanza tra gli spicchi
                    centerSpaceRadius: 0, //vuoto nel centro
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget infoBullet(String testoPrincipale, IconData iconData, Color color, String testoSecondario,context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          IconButton(onPressed: () => apriApprofondimento(context, testoSecondario), icon: Icon(Icons.info, size: 20, color: Colors.blue)),
          Icon(iconData, color: color, size: 30),
          SizedBox(width: 8),
          Text(testoPrincipale, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
        ],
      ),
    );
  }
  
  apriApprofondimento(context, String testoSecondario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mini schermata"),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
          content: 
          Text(testoSecondario),
          contentTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.black),
        );
      },
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