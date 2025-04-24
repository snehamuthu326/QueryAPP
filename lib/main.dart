import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontendmcet/admin.dart';
import 'package:frontendmcet/hod.dart';
import 'package:http/http.dart' as http;
import 'package:frontendmcet/probdesc.dart'; 

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Query APP',
      theme: ThemeData(hintColor:  Color.fromARGB(255, 255, 125, 25)),
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  /*
  Future<void> login(String username, String password) async {
    //10.0.2.2 for android emulator
    //for mobile device use your local ip address 192.168.133.178
    final String apiUrl = "http://192.168.133.178:8080/api/user/test";

    try {
      //final Map<String, dynamic> requestBody = {
      //"username": username,
      //"password": password,
      //};

      // Send the POST request
      //final res = await http.post(
      // Uri.parse(apiUrl),
      // headers: {"Content-Type": "application/json"},
      // body: jsonEncode(requestBody),
      //);

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print("Login Successful: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Backend says: ${response.body}")),
        );
      } 
    } catch (e) {
      print("API call failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network Error, check connection!")),
      );
    }
  }

  Future<void> _submit() async {
    try {
      if (_formKey.currentState!.validate()) {
        print("Validation successful");
        String username = _usernameController.text;
        String password = _passwordController.text;
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wait for a While!")),);
        print("Username: $username, Password: $password");
        await login(username, password);
      }
    } catch (e) {
      print("Error during submission: $e");
    }
  }
  */

/*
  void login(BuildContext context) {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if(username == 'admin' && password == '123'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProbDesc()),  // const ProbDesc()),
      );
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Credentials!")),
      );
    }
  }
*/
Future<void> loginUser(String uname, String passkey) async {
  //final url = Uri.parse('http://10.0.2.2:8080/api/user/login'); 
  final url = Uri.parse('http://192.168.133.21:8080/api/user/login'); 
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'uname': uname,
        'passkey': passkey,
      }),
    );
    print('👍Response status: ${response.body}');
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      String userName = data['name'];
      print('✅ ${response.body}'); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data),),
      );
      if(data['role']== "F"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProbDesc()),
        );
      } else if(data['role']== "H"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HodScreen(name: userName,)),
        );
      } else if(data['role']== "A"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Admin()),
        );
      }
      
    } else if (response.statusCode == 401) {
      print('❌ Unauthorized: ${response.body}'); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wrong Credentials!")),
      );
    } else {
      print('⚠️ Error: ${response.statusCode} - ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network Error, check connection!")),
      );
    }
  } catch (e) {
    print('🚫 Exception: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Exception Occurred, API call is not performed check connection!")),
    );
  }
}


  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      print("Username: $username, Password: $password");
      await loginUser(username, password); 
      //login(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 125, 25),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: EdgeInsets.all(8),
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Username",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Times New Roman',
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Enter your username..',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Times New Roman',
                              color: Colors.white,
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Enter your Password..',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Forget Password?",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: _submit,// () => login(context),// _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
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


/*import 'package:flutter/material.dart';

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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
