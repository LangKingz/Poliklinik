import 'package:flutter/material.dart';
import 'package:poliklinik/AntrianFormPage.dart';
import 'package:poliklinik/database/DatabaseHelper.dart';
import 'package:poliklinik/model/Antrian.dart';

class Homepages extends StatefulWidget {
  const Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  late Future<List<Antrian>> antrian;

  @override
  void initState() {
    super.initState();
    antrian = DatabaseHelper().getAntrianList();
  }

  void _refreshAntrianList() {
    setState(() {
      antrian = DatabaseHelper().getAntrianList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Antrian'),
      ),
      body: FutureBuilder<List<Antrian>>(
        future: antrian,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data antrian.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final antrian = snapshot.data![index];
                return ListTile(
                  title: Text(antrian.namaPasien),
                  subtitle: Text('Nomor Antrian: ${antrian.nomorAntrian}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AntrianFormPage(
                        antrian: antrian,
                        onSave: _refreshAntrianList,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper().deleteAntrian(antrian.id!);
                      _refreshAntrianList();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AntrianFormPage(onSave: _refreshAntrianList),
            ),
          );
        },
      ),
    );
  }
}
