import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Companies> fetchdetails = [];
  Future<List<Companies>> fetchCompanies() async {
    var jsonData = json.decode('''
[{"id":1,"image":"http://dummyimage.com/156x118.jpg/cc0000/ffffff","title":"Hauck and Sons","items":"1/22/2019"},{"id":2,"image":"http://dummyimage.com/176x232.jpg/5fa2dd/ffffff","title":"Hettinger-Gulgowski","items":"3/9/2019"},{"id":3,"image":"http://dummyimage.com/111x249.jpg/5fa2dd/ffffff","title":"Kemmer Inc","items":"7/17/2019"},{"id":4,"image":"http://dummyimage.com/185x210.jpg/dddddd/000000","title":"Leffler, Walter and Kling","items":"1/19/2019"},{"id":5,"image":"http://dummyimage.com/233x173.jpg/cc0000/ffffff","title":"Williamson-Koepp","items":"11/1/2019"},{"id":6,"image":"http://dummyimage.com/129x187.jpg/5fa2dd/ffffff","title":"Stehr-Koss","items":"5/6/2019"},{"id":7,"image":"http://dummyimage.com/154x189.jpg/cc0000/ffffff","title":"Kuhn-Murphy","items":"5/26/2019"},{"id":8,"image":"http://dummyimage.com/172x130.jpg/cc0000/ffffff","title":"Corkery and Sons","items":"9/16/2019"},{"id":9,"image":"http://dummyimage.com/126x173.jpg/dddddd/000000","title":"Christiansen-Romaguera","items":"11/20/2019"},{"id":10,"image":"http://dummyimage.com/194x162.jpg/dddddd/000000","title":"Effertz, Runolfsdottir and Waelchi","items":"7/29/2019"}]
''');
    for (var coval in jsonData) {
      Companies companies = Companies(coval['id'], coval['image'], coval['title'], coval['items']);
      fetchdetails.add(companies);
    }
    return fetchdetails;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCompanies();
    print('fetching');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Cutom Feed',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40, color: Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {}),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchCompanies(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, int index) {
                    return getBookDetails(
                        snapshot.data![index].id, snapshot.data![index].image, snapshot.data![index].title, snapshot.data![index].items);
                  });
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Companies {
  int id;
  String title;
  String image;
  String items;

  Companies(this.id, this.title, this.image, this.items);
}

Widget getBookDetails(int id, String title, String image, String items) {
  return Container(
    width: 180,
    height: double.infinity,
    margin: const EdgeInsets.all(10),
    decoration:
        BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
    child: Column(
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        Text(id.toString())
      ],
    ),
  );
}
