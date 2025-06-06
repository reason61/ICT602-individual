import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab Navigation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(title: 'Individual Assignment'),
    );
  }
}

class MainScreen extends StatefulWidget {

  const MainScreen({super.key, required this.title});

  final String title;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dividend-er'),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: 'Home',
            ),
            Tab(
              icon: Icon(Icons.info),
              text: 'About',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomePage(),
          AboutPage(),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {

  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController investedController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();

  double? monthlyDividend;
  double? totalDividend;

  void calculateDividend() {
    final double? invested = double.tryParse(investedController.text);
    final double? annualRate = double.tryParse(rateController.text);
    final int? months = int.tryParse(monthsController.text);

    if (invested != null && annualRate != null && months != null) {
      final monthlyRate = annualRate / 12 / 100;
      final monthly = invested * monthlyRate;
      final total = monthly * months;

      setState(() {
        monthlyDividend = monthly;
        totalDividend = total;
      });
    } else {
      setState(() {
        monthlyDividend = null;
        totalDividend = null;
      });
    }
  }

  final TextInputFormatter monthFormatter = TextInputFormatter.withFunction(
        (oldValue, newValue) {
      if (newValue.text.isEmpty) return newValue;

      final int? value = int.tryParse(newValue.text);
      if (value == null || value < 1 || value > 12) {
        return oldValue;
      }
      return newValue;
    },
  );
  final TextInputFormatter annualFormatter = TextInputFormatter.withFunction(
        (oldValue, newValue) {
      if (newValue.text.isEmpty) return newValue;

      final int? value = int.tryParse(newValue.text);
      if (value == null || value < 1 || value > 100) {
        return oldValue;
      }
      return newValue;
    },
  );
  final TextInputFormatter investFormatter = TextInputFormatter.withFunction(
        (oldValue, newValue) {
      if (newValue.text.isEmpty) return newValue;

      final int? value = int.tryParse(newValue.text);
      if (value == null || value < 1) {
        return oldValue;
      }
      return newValue;
    },
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Invested Amount
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: investedController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, investFormatter],
                decoration: InputDecoration(
                  hintText: 'Invested Fund Amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Annual Rate
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  annualFormatter,
                ],
                decoration: InputDecoration(
                  hintText: 'Annual Dividend Rate (%)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Months
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: monthsController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  monthFormatter,
                ],
                decoration: InputDecoration(
                  hintText: 'Months Invested',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Calculate Button
            ElevatedButton(
              onPressed: calculateDividend,
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            // Results
            if (monthlyDividend != null && totalDividend != null) ...[
              Text(
                'Monthly Dividend: RM ${monthlyDividend!.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Total Dividend: RM ${totalDividend!.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {

  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0.3,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/About.png', // Replace with your image path
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image fails to load
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Dividend-er',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'This app\'s purpose is to calculate total dividend',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Syahril Rumizam bin Abdul Razak \n 2024568363 \n CDCS2515A',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              final Uri url = Uri.parse('https://github.com/reason61/ICT602-individual');
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              'My Github',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            '\u00a9 made for study and assignment purpose',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}