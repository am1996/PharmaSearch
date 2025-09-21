import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: const Text("Home"),
              onTap: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("hello world"),behavior: SnackBarBehavior.fixed));
              },
            )
          ],
        ),
      ),
      body: ListView.builder(itemBuilder: (context,index) => Card(
        margin: EdgeInsets.only(bottom: 50),
        child: Text('hello world'),
      ),cacheExtent: 1000, physics: BouncingScrollPhysics(),padding: EdgeInsets.all(10),)
    );
  }
}
