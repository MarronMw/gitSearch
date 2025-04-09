import 'package:flutter/material.dart';

//APICLIENTS
import 'users_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Search for GitHub Users'),
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
  final TextEditingController _searchController = TextEditingController();

   final usersApi=UsersApi();

  //API CALLS AND HANDLES
  void handle_search_user()async{
    String username=_searchController.text;
    final user =await usersApi.getUserByUsername(username);
    print('TYPE:${user.runtimeType}');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 166, 174, 248),
        title: Text(widget.title),
      ),
      body: Center(       // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
      
          
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/icons8-github-120.png')
              ],
            ),
            Padding(
               padding: EdgeInsets.symmetric(horizontal: 10.0),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                          ),
                          labelText: "Whom are you planning to hire?",
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.black,
                      ),
                      child: TextButton(
                          onPressed: (){
                            handle_search_user();
                            final searchText = _searchController.text;

                            
                            // below is to show diolog box with searched text for testing purposes marron listen
                            showDialog(context: context, 
                                builder: (context) => AlertDialog(
                                  title: Text("Search Result"),
                                  content: Text('Youve searched for $searchText'),
                                )
                            );
                          },
                          child: Icon(Icons.search, size: 30, color: Colors.white,)
                      ),
                    )
                  ]
                ),
            ),
          ],
        ),
      ),
      
     );
  }
}
