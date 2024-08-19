import 'package:flutter/material.dart';
import 'package:poliklinik/database/DatabaseHelper.dart';
import 'package:poliklinik/model/Antrian.dart';

class AntrianFormPage extends StatefulWidget {
  final Antrian? antrian;
  final VoidCallback onSave;

  AntrianFormPage({this.antrian, required this.onSave});

  @override
  _AntrianFormPageState createState() => _AntrianFormPageState();
}

class _AntrianFormPageState extends State<AntrianFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaPasienController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _nomorAntrianController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.antrian != null) {
      _namaPasienController.text = widget.antrian!.namaPasien;
      _tanggalController.text = widget.antrian!.tanggal;
      _nomorAntrianController.text = widget.antrian!.nomorAntrian.toString();
    }
  }

  @override
  void dispose() {
    _namaPasienController.dispose();
    _tanggalController.dispose();
    _nomorAntrianController.dispose();
    super.dispose();
  }

  void _saveAntrian() async {
    if (_formKey.currentState!.validate()) {
      final namaPasien = _namaPasienController.text;
      final tanggal = _tanggalController.text;
      final nomorAntrian = int.parse(_nomorAntrianController.text);

      final antrian = Antrian(
        id: widget.antrian?.id,
        namaPasien: namaPasien,
        tanggal: tanggal,
        nomorAntrian: nomorAntrian,
      );

      if (widget.antrian == null) {
        await DatabaseHelper().insertAntrian(antrian);
      } else {
        await DatabaseHelper().updateAntrian(antrian);
      }

      widget.onSave();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.antrian == null ? 'Tambah Antrian' : 'Edit Antrian'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _namaPasienController,
                decoration: InputDecoration(labelText: 'Nama Pasien'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Pasien tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(labelText: 'Tanggal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomorAntrianController,
                decoration: InputDecoration(labelText: 'Nomor Antrian'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Antrian tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Nomor Antrian harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAntrian,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
