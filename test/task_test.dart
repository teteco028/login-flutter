import 'package:flutter_test/flutter_test.dart';
import 'package:neon_daily/models/task.dart';

void main() {
  test('ordena pendentes e concluídas alfabeticamente sem alterar a lista', () {
    final original = [
      Task(title: 'Estudar Flutter', completed: true),
      Task(title: 'Lavar carro'),
      Task(title: 'Comprar pão'),
      Task(title: 'Academia', completed: true),
      Task(title: 'Enviar relatório'),
    ];

    final sorted = sortTasks(original);

    expect(
      sorted.map((task) => task.title).toList(),
      [
        'Comprar pão',
        'Enviar relatório',
        'Lavar carro',
        'Academia',
        'Estudar Flutter',
      ],
    );
    expect(original.first.title, 'Estudar Flutter');
    expect(sorted[0].completed, isFalse);
    expect(sorted[3].completed, isTrue);
  });
}
