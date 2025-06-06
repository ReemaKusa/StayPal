import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:staypal/screens/admin/viewmodels/hotel_manager_viewmodel.dart';
import 'package:staypal/screens/admin/views/event_organizer_view.dart';
import 'package:staypal/screens/auth/views/auth_entry_view.dart';
// import 'package:staypal/screens/profile/booking_complete.dart';
import 'package:staypal/screens/profile/viewmodels/profile_viewmodel.dart';

import 'package:staypal/DB/firebase_options.dart'; 

// import 'package:staypal/screens/auth/test_firestore_screen.dart'; 
import 'package:staypal/screens/profile/views/my_profile.dart';
import 'package:provider/provider.dart';
import 'package:staypal/screens/wishlistPage/views/wishlist_view.dart';
import 'package:staypal/screens/searchResult/views/search_result_page.dart';
import 'package:staypal/screens/homePage/views/home_page.dart';
import 'package:staypal/screens/admin/views/admin_dashboard_view.dart';
import 'package:staypal/screens/admin/views/hotel_manager_view.dart';
// import 'package:staypal/screens/admin/views/event_organizer_view.dart';
// import 'package:staypal/screens/admin/views/event_organizer_view.dart';
//import 'package:staypal/widgets/role_landing_view.dart';
//import 'package:staypal/screens/appSplash/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (_) => ProfileViewModel(),
  ),

        ChangeNotifierProvider(create: (_) => HotelManagerViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StayPal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home:  MyProfile(),
      //home: HomePage(),
      //home:MainScreen(),
      //home: MyProfile(),
      //home:AuthEntryScreen(),
      //home: AdminDashboard(),

    //home: HotelManagerView(),
     home: EventOrganizerView(),

    

      //home: HomePage(),

     // home:RoleLandingView(),
     // home: SplashScreen(),


      routes: {
        '/wishlist': (context) => WishListPage(),
        '/searchresult': (ctx) => SearchResultPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => MyProfile(),
        '/auth': (context) => AuthEntryView(),
        '/login': (context) => AuthEntryView(),
        '/adminDashboard': (context) => AdminDashboard(),
        '/hotelManagerHome': (context) => HotelManagerView(),
        '/eventOrganizerHome': (context) => EventOrganizerView(),
        '/userHome': (context) => HomePage(),


      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}