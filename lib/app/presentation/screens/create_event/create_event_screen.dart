// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:gatherly/app/data/models/event_model.dart';
import 'package:gatherly/app/domain/usecase/create_event_usecase.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';



class CreateEventScreen extends StatefulWidget {
  final int id;

  const CreateEventScreen({super.key, required this.id});


  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  DateTime _selectedDateTime = DateTime.now();
  String _location = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final createEventUsecase = Modular.get<CreateEventUsecase>();

      final newEvent = EventModel(
        id: "",
        title: _title,
        description: _description,
        date: _selectedDateTime,
        location: _location,
        creatorId: "",
        participants: [],
        isActive: true
      );

      try {
        await createEventUsecase.createEvent(newEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Evento criado com sucesso!')),
        );
        _clearForm(); // Limpa o formulário após a criação do evento
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar o evento: $e')),
        );
      }

    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _title = '';
      _description = '';
      _selectedDateTime = DateTime.now();
      _location = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Evento'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'Data: ${_formatDateTime(_selectedDateTime)}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: _pickDateTime,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Localização'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma localização';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _location = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Criar Evento'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    // Escolher a data
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    // Escolher a hora
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (pickedDate != null && pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    return '${dateFormat.format(dateTime)} ${timeFormat.format(dateTime)}';
  }

}
