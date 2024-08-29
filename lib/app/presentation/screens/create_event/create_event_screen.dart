// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';


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
  DateTime? _eventDate;
  TimeOfDay? _eventTime;
  String _location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Evento'),
        backgroundColor: Colors.blueAccent.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildForm(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Salvar Evento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Título',
            onSaved: (value) => _title = value ?? '',
            validator: (value) => value!.isEmpty ? 'O título é obrigatório' : null,
          ),
          _buildTextField(
            label: 'Descrição',
            onSaved: (value) => _description = value ?? '',
            validator: (value) => value!.isEmpty ? 'A descrição é obrigatória' : null,
            maxLines: 3,
          ),
          _buildDateTimePicker(
            label: 'Data',
            selectedDate: _eventDate,
            onSelectDate: (date) => setState(() => _eventDate = date), 
            onSelectTime: (TimeOfDay ) {  },
          ),
          _buildDateTimePicker(
            label: 'Hora',
            selectedTime: _eventTime,
            onSelectTime: (time) => setState(() => _eventTime = time),
            isTimePicker: true, 
            onSelectDate: (DateTime ) {  },
          ),
          _buildTextField(
            label: 'Local',
            onSaved: (value) => _location = value ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    required void Function(DateTime?) onSelectDate,
    required void Function(TimeOfDay?) onSelectTime,
    bool isTimePicker = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () async {
          if (isTimePicker) {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );
            if (pickedTime != null) onSelectTime(pickedTime);
          } else {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) onSelectDate(pickedDate);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              hintText: isTimePicker
                  ? (selectedTime != null ? selectedTime.format(context) : 'Selecione a hora')
                  : (selectedDate != null ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' : 'Selecione a data'),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            onSaved: (value) {},
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Lógica para salvar o evento
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Evento criado com sucesso')),
      );
      // Navegar ou limpar o formulário, conforme necessário
    }
  }
}
