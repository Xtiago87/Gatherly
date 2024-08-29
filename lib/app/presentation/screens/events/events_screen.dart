import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';


class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<Map<String, String>> events = [
    {
      'name': 'Workshop de Flutter',
      'date': '10 de setembro, 2024',
      'location': 'Centro de Convenções',
    },
    {
      'name': 'Hackathon de Tecnologia',
      'date': '15 de setembro, 2024',
      'location': 'Espaço Tech',
    },
    {
      'name': 'Palestra sobre IA',
      'date': '20 de setembro, 2024',
      'location': 'Universidade XYZ',
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Pesquisar eventos...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Lógica de pesquisa (opcional se for em tempo real)
                    },
                  ),
                ],
              ),
            ),
            Text("Meus eventos"),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  if (searchQuery.isEmpty || events[index]['name']!.toLowerCase().contains(searchQuery.toLowerCase())) {
                    return _buildEventCard(
                      events[index]['name']!,
                      events[index]['date']!,
                      events[index]['location']!,
                    );
                  }
                  return Container(); // Retorna um container vazio se o evento não corresponder à pesquisa
                },
              ),
            ),
            Text("Outros eventos"),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  if (searchQuery.isEmpty || events[index]['name']!.toLowerCase().contains(searchQuery.toLowerCase())) {
                    return _buildEventCard(
                      events[index]['name']!,
                      events[index]['date']!,
                      events[index]['location']!,
                    );
                  }
                  return Container(); // Retorna um container vazio se o evento não corresponder à pesquisa
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
              onPressed: () {
                Modular.to.pushNamed('/create_event/-1');
              },
              child: Icon(Icons.add),
              tooltip: 'Criar Novo Evento',
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () {
                // Lógica para confirmar presença
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Navegar para a tela de detalhes do evento
              },
            ),
          ],
        ),
      ),
    );
  }
}
