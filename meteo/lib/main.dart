import 'package:flutter/material.dart';
import 'dart:convert'; // per jsonDecode
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';// per i grafici
import 'package:sizer/sizer.dart';
import 'globals.dart' as globals;

void main() {
  runApp(EcoWeatherApp());
}

class EcoWeatherApp extends StatelessWidget {
  const EcoWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false, // Disabilita il banner di debug
          home: HomeScreen(),
        );
      },
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
            Icon(Icons.eco, color: Colors.green, size: 7.w),
            SizedBox(width: 2.w),
            Text("EcoWeather",
              style: TextStyle(
                fontSize: 6.w,
                fontWeight: FontWeight.bold,
                color: Colors.green[800]
              )
            )
          ]
        ),
      ),

      endDrawer: EndDrawerGlobale(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => mostraDettagliMeteo(context),
                // Nome città e data a sinistra e simbolo Weather
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                mostraCambioCitta(context);
                              },  
                              child: Row(
                                children: [
                                Text(globals.nomeCitta,
                                  style: TextStyle(fontSize: 10.w, fontWeight: FontWeight.bold)),
                                Icon(Icons.keyboard_arrow_down, size: 5.w, color: Colors.grey[700]),
                              ],
                            ),
                          ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(globals.data,
                              style: TextStyle(fontSize: 4.5.w, color: Colors.grey[700])),
                            Text("  20°",
                              style:TextStyle(fontSize:  14.w, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Icon(Icons.wb_cloudy, size: 20.w, color: Colors.grey[700])
                  ],
                ),
              ),
                  // Caselle con le previsioni successive
              SizedBox(height: 3.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    forecastCard("Gio", Icons.cloud, "18°"),
                    forecastCard("Ven", Icons.cloud, "20°"),
                    forecastCard("Sab", Icons.wb_sunny, "22°"),
                    forecastCard("Dom", Icons.wb_sunny_outlined, "21°"),
                  ],
                ),

                SizedBox(height: 0.9.w),
                
                // giudizio ambientale
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 4.w),
                      Text("BILANCIO AMBIENTALE",
                        style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2.w),
                
                      // Faccina
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                          radius: 9.5.w,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.sentiment_satisfied_alt_outlined,
                              size: 15.w, color: Colors.black),
                          ),

                          SizedBox(width: 4.w),
                                        
                          // Bottone APPROFONDISCI
                          OutlinedButton(
                            onPressed: () => mostraInquinamento(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black, width: 0.4.w),
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.w),
                            ),
                            child : Text(
                              "APPROFONDISCI",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 3.5.w,
                                color: Colors.black),
                            )
                          ),
                        ],
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
            style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.bold)),
        SizedBox(height: 1.w),
        Icon(icon, size: 7.5.w, color: Colors.grey[700]),
        SizedBox(height: 1.w),
        Text(temp, style: TextStyle(fontSize: 4.w))
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
  
  void mostraDettagliMeteo(BuildContext context) {
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

  void mostraCambioCitta(BuildContext context) {
  final TextEditingController controller = TextEditingController();
  final List<String> cittaPredefinite = ['Roma', 'Milano', 'Firenze', 'Napoli', '  Pisa ', 'Pistoia', 'Venezia', '  Bari  '];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 5.w,
          right: 5.w,
          top: 5.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_city, size: 10.w, color: Colors.green),
            SizedBox(height: 3.w),
            Text(
              "Cambia città",
              style: TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.w),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Inserisci il nome della città",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => cambiaCitta(controller.text, context),
            ),
            SizedBox(height: 4.w),
            ElevatedButton.icon(
              onPressed: () => cambiaCitta(controller.text, context),
              icon: Icon(Icons.check, color: Colors.black,),
              label: Text("Conferma", style: TextStyle(fontSize: 4.w, color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
            ),
            SizedBox(height: 5.w),
            Divider(),
            Text("Oppure scegli una città:", style: TextStyle(fontSize: 4.w)),
            SizedBox(height: 2.w),
            Wrap(
              spacing: 2.w,
              children: cittaPredefinite.map((citta) {
                return ActionChip(
                  label: Text(citta),
                  onPressed: () => cambiaCitta(citta, context),
                  backgroundColor: Colors.green[100],
                );
              }).toList(),
            ),
            SizedBox(height: 5.w),
          ],
        ),
      );
    },
  );
}


  void cambiaCitta(String value, BuildContext context) {
    if (value.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inserisci una città valida")),
      );
      return;
    }

    setState(() {
      globals.nomeCitta = value.trim();
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Città cambiata in ${globals.nomeCitta}"),
        duration: Duration(seconds: 2),
      ),
    );
  }


  // PARTE PER API, DA AGGIUNGERE LA KEY
  Future<double> fetchTemperature(String nomeCitta) async {
    final apiKey = 'LA_TUA_API_KEY'; // << qui metti la tua vera chiave
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$nomeCitta&appid=$apiKey&units=metric';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Icon(Icons.eco, color: Colors.green, size: 7.w),
            SizedBox(width: 2.w),
            Text(
              "EcoWeather",
              style: TextStyle(
                fontSize: 6.w,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
      endDrawer: EndDrawerGlobale(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.2.w),
              Text(
                "QUALITÀ DELL'ARIA",
                style: TextStyle(
                  fontSize: 8.w,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 100, 255),
                ),
              ),
              SizedBox(height: 6.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoBullet("AQI: 85 ", Icons.speed, Colors.orange, "L’Indice di Qualità dell’Aria (AQI) valuta quanto l’aria è salubre, combinando diversi inquinanti in un unico valore.", context),
                        infoBullet("PM 2.5: 35µg/m³ ", Icons.blur_on, Colors.red, "Micropolveri con diametro inferiore a 2.5 µm: penetrano nei polmoni e possono entrare nel sangue, causando seri danni alla salute.", context),
                        infoBullet("PM 10: 60µg/m³ ", Icons.blur_on, Colors.orange, "Particelle sospese con diametro inferiore a 10 µm: possono essere inalate e causare problemi respiratori e infiammazioni.", context),
                        infoBullet("NO2: 45µg/m³ ", Icons.science, Colors.green, "Il biossido di azoto è un gas irritante prodotto soprattutto dai veicoli a motore e può peggiorare l’asma e altre malattie respiratorie.", context),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoBullet("O3: 70µg/m³ ", Icons.cloud, Colors.green, "L’ozono troposferico si forma nell’atmosfera e può causare irritazioni a occhi e polmoni, soprattutto nelle giornate calde e soleggiate.", context),
                        infoBullet("CO: 0.7 mg/m³ ", Icons.local_fire_department, Colors.orange, "Il monossido di carbonio è un gas inodore e pericoloso prodotto dalla combustione incompleta, che riduce l’ossigeno trasportato nel sangue.", context),
                        //SizedBox(height: 0.5.w),
                        infoBullet("SO2: 10µg/m³‎ ‎ ", Icons.science, Colors.green, "Il biossido di zolfo proviene soprattutto da centrali a carbone e attività industriali, ed è dannoso per il sistema respiratorio.", context),
                        //SizedBox(height: 4.5.w),
                        infoBullet("NH3: 15µg/m³ ", Icons.science, Colors.red, "L’ammoniaca è rilasciata principalmente dall’agricoltura e può contribuire alla formazione di particolato fine nell’aria.", context),
                      ]
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.w),
              Text(
                "EMISSIONI DI CO₂",
                style: TextStyle(
                  fontSize: 8.w,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
              ),
              SizedBox(height: 5.w),
              SizedBox(
                height: 60.w,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 45,
                        color: Colors.red,
                        title: 'Trasporti\n45%',
                        radius: 28.w,
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      PieChartSectionData(
                        value: 30,
                        color: Colors.orange,
                        title: 'Industria\n30%',
                        radius: 28.w,
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      PieChartSectionData(
                        value: 15,
                        color: Colors.green,
                        title: 'Edifici\n15%',
                        radius: 28.w,
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      PieChartSectionData(
                        value: 10,
                        color: Colors.blue,
                        title: 'Agricoltura\n10%',
                        radius: 28.w,
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                  ),
                ),
              ),

              SizedBox(height: 8.w),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget infoBullet(
    String label,
    IconData iconData,
    Color color,
    String description,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => apriApprofondimento(context, label, description),
            icon: Icon(Icons.info, size: 4.w, color: Colors.blue),
          ),
          CircleAvatar(
            radius: 3.5.w,
            backgroundColor: color,
            child: Icon(iconData,
            size: 6.w, color: Colors.black),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void apriApprofondimento(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 6.w)),
        content: Text(content, style: TextStyle(fontSize: 4.w)),
      ),
    );
  }
}

class DettagliMeteoScreen extends StatelessWidget {
  const DettagliMeteoScreen({super.key});
  static const days = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Icon(Icons.eco, color: Colors.green, size: 7.w),
            SizedBox(width: 2.w),
            Text(
              "EcoWeather",
              style: TextStyle(
                fontSize: 6.w,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
      endDrawer: EndDrawerGlobale(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30.w,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.wb_sunny,
                      size: 20.w,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          globals.data + globals.nomeCitta,
                          style: TextStyle(
                            fontSize: 4.5.w,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 1.w),
                        Text(
                          "SOLEGGIATO",
                          style: TextStyle(
                            fontSize: 7.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.w),
                        Text(
                          "25°C",
                          style: TextStyle(
                            fontSize: 10.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 0.5.w),
                        Text(
                          "Percepiti: 27°C",
                          style: TextStyle(
                            fontSize: 4.w,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.w),
              Divider(),
              SizedBox(height: 3.w),
              infoRow("Vento", "10 km/h Nord", Icons.air, Colors.blue),
              infoRow("Umidità", "60%", Icons.water_drop, Colors.lightBlue),
              infoRow("Pressione", "1015 hPa", Icons.speed, Colors.orange),
              infoRow("Indice UV", "5", Icons.wb_sunny, Colors.deepOrange),
              infoRow("Visibilità", "10 km", Icons.visibility, Colors.grey),
              infoRow("Precipitazioni", "0 mm", Icons.grain, Colors.indigo),
              infoRow("Copertura nuvolosa", "20%", Icons.cloud, Colors.blueGrey),
              infoRow("Punto di rugiada", "15°C", Icons.ac_unit, Colors.cyan),
              infoRow("Qualità dell’aria", "AQI 42", Icons.air_outlined, Colors.green),
              infoRow("Livello di polline", "Medio", Icons.local_florist, Colors.purple),
              Center(
                child: Text(
                  "GRAFICI TEMPERATURA",
                  style: TextStyle(
                    fontSize: 8.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
              ),
              SizedBox(height: 3.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                height: 40.h, // Altezza responsive
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 6,
                    minY: 10,
                    maxY: 24,
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        spots: [
                          FlSpot(0, 14),
                          FlSpot(1, 16),
                          FlSpot(2, 18),
                          FlSpot(3, 19),
                          FlSpot(4, 21),
                          FlSpot(5, 20),
                          FlSpot(6, 22),
                        ],
                        color: Colors.deepOrange,
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 8.w,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= days.length) return const SizedBox();
                            return Text(
                              days[i],
                              style: TextStyle(fontSize: 4.w),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: 12.w,
                          getTitlesWidget: (value, meta) {
                            return Center(
                              child: Text(
                                '${value.toInt()}°',
                                style: TextStyle(fontSize: 4.w),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 2,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5.w,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String valore, IconData iconData, Color iconColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Row(
        children: [
          Icon(iconData, size: 6.w, color: iconColor),
          SizedBox(width: 3.w),
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 4.w,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              valore,
              style: TextStyle(fontSize: 4.w),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Info",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              infoCard(
                title: "Versione App",
                description: "1.0.0 - Ultima versione stabile dell'app meteo eco-friendly.",
                icon: Icons.info,
                color: Colors.blue,
              ),
              infoCard(
                title: "Sviluppatore",
                description: "Classe 3IA 2024/2025 - I.T.T.S Fedi-Fermi di Pistoia\n\nSviluppato da: \n- Cai Dal Pino Gabriele\n- Arinci Andrea\n- Con il sostengo della classe",
                icon: Icons.person,
                color: Colors.green,
              ),
              infoCard(
                title: "Contatti",
                description: "- caidalpino.gabriele@studenti-ittfedifermi.edu.it\n\n - arinci.andrea@studenti-ittfedifermi.edu.it\n\n - d.bini@ittfedifermi.edu.it",
                icon: Icons.mail,
                color: Colors.redAccent,
              ),
              infoCard(
                title: "Privacy Policy",
                description: "I tuoi dati non vengono condivisi in nessun modo.",
                icon: Icons.lock,
                color: Colors.deepOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 35),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class EndDrawerGlobale extends StatelessWidget {
  const EndDrawerGlobale({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 50.h,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.eco, color: Colors.greenAccent, size: 7.w),
                Text("EcoWeather",
                  style: TextStyle(color: Colors.white, fontSize: 6.w)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Info"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfoScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Impostazioni"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImpostazioniScreen()),
            ),
          ),
        ],
      ),
    );
  }
}


class ImpostazioniScreen extends StatelessWidget {
  const ImpostazioniScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Icon(Icons.settings, color: Colors.grey[700], size: 7.w),
            SizedBox(width: 2.w),
            Text(
              "Impostazioni",
              style: TextStyle(
                fontSize: 6.w,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
      endDrawer: EndDrawerGlobale(),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            settingTile(
              icon: Icons.dark_mode,
              title: "Tema Scuro",
              description: "Attiva o disattiva il tema scuro dell'app.",
              onTap: () {
                apriDialogo(context, "Tema Scuro", "Funzionalità ancora in sviluppo.");
              },
            ),
            settingTile(
              icon: Icons.notifications,
              title: "Notifiche",
              description: "Gestisci le notifiche sull'inquinamento e il meteo.",
              onTap: () {
                apriDialogo(context, "Notifiche", "Riceverai notifiche solo se abilitate.");
              },
            ),
            settingTile(
              icon: Icons.update,
              title: "Aggiornamenti",
              description: "Frequenza con cui l'app aggiorna i dati.",
              onTap: () {
                apriDialogo(context, "Aggiornamenti", "I dati vengono aggiornati ogni ora.");
              },
            ),
            settingTile(
              icon: Icons.language,
              title: "Lingua",
              description: "Seleziona la lingua preferita per l'app.",
              onTap: () {
                apriDialogo(context, "Lingua", "Lingua attuale: Italiano.");
              },
            ),
            settingTile(
              icon: Icons.info,
              title: "Info App",
              description: "Versione, sviluppatori e licenze.",
              onTap: () {
                apriDialogo(context, "Info App", "EcoWeather v1.0\nSviluppata da Cai e Arinci :)");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget settingTile({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.w),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 5.w,
              backgroundColor: Colors.teal[100],
              child: Icon(icon, color: Colors.teal[700], size: 6.w),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 1.w),
                  Text(
                    description,
                    style: TextStyle(fontSize: 4.w, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void apriDialogo(BuildContext context, String titolo, String contenuto) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titolo, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(contenuto),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
