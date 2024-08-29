import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {

 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Próximos Eventos
              _buildSectionTitle('Próximos Eventos'),
              _buildEventCard('Evento 1', '10 de setembro, 2024', 'Local 1'),
              _buildEventCard('Evento 2', '15 de setembro, 2024', 'Local 2'),
      
              SizedBox(height: 24.0),
      
              // Eventos Criados Recentemente
              _buildSectionTitle('Eventos Criados Recentemente'),
              _buildEventCard('Evento Criado 1', '2 de setembro, 2024', 'Local 3'),
              _buildEventCard('Evento Criado 2', '5 de setembro, 2024', 'Local 4'),
      
              SizedBox(height: 24.0),
      
              // Eventos Confirmados
              _buildSectionTitle('Eventos Confirmados'),
              _buildEventCard('Evento Confirmado 1', '18 de setembro, 2024', 'Local 5'),
              _buildEventCard('Evento Confirmado 2', '20 de setembro, 2024', 'Local 6'),
      
              SizedBox(height: 24.0),
      
              // Sugestões de Eventos
              _buildSectionTitle('Sugestões de Eventos'),
              _buildEventCard('Evento Sugerido 1', '22 de setembro, 2024', 'Local 7'),
              _buildEventCard('Evento Sugerido 2', '25 de setembro, 2024', 'Local 8'),
            ],
          ),
        ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEventCard(String eventName, String eventDate, String eventLocation) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(eventName),
        subtitle: Text('$eventDate - $eventLocation'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navegar para a tela de detalhes do evento
        },
      ),
    );
  }
}
