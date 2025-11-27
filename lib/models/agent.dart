class Agent {
  final String id;
  final String name;
  final String description;

  Agent({required this.id, required this.name, required this.description});

  factory Agent.fromMap(Map<String, dynamic> map) {
    return Agent(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
