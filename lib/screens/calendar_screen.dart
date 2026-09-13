import 'package:flutter/material.dart';
import '../models/note.dart';
import '../storage/notes_storage.dart';
import '../theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selected = DateTime.now();
  final _monthsRu = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
  ];
  final _daysRu = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _shift(int delta) => setState(() =>
      _month = DateTime(_month.year, _month.month + delta));

  Future<void> _openDay(DateTime day) async {
    setState(() => _selected = day);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _DayNotesSheet(dateKey: _key(day)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final first = DateTime(_month.year, _month.month);
    final offset = (first.weekday - 1) % 7; // неделя с понедельника
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('${_monthsRu[_month.month - 1]} ${_month.year}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton.filledTonal(
                    onPressed: () => _shift(-1),
                    icon: const Icon(Icons.chevron_left)),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    _month = DateTime(today.year, today.month);
                    _selected = today;
                  }),
                  child: const Text('Сегодня'),
                ),
                const Spacer(),
                IconButton.filledTonal(
                    onPressed: () => _shift(1),
                    icon: const Icon(Icons.chevron_right)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _daysRu
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(d,
                              style: TextStyle(
                                  color: scheme.outline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
              itemCount: offset + daysInMonth,
              itemBuilder: (_, i) {
                if (i < offset) return const SizedBox();
                final day = i - offset + 1;
                final date = DateTime(_month.year, _month.month, day);
                final isToday = date.year == today.year &&
                    date.month == today.month && date.day == today.day;
                final isSel = date.year == _selected.year &&
                    date.month == _selected.month && date.day == _selected.day;
                final hasNotes = NotesStorage.of(_key(date)).isNotEmpty;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _openDay(date),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSel
                          ? scheme.primary
                          : isToday
                              ? scheme.primaryContainer
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: isToday && !isSel
                          ? Border.all(color: scheme.primary)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$day',
                            style: TextStyle(
                              color: isSel
                                  ? scheme.onPrimary
                                  : scheme.onSurface,
                              fontWeight: isToday || isSel
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            )),
                        if (hasNotes)
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            width: 5, height: 5,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSel ? scheme.onPrimary : AppTheme.seed),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DayNotesSheet extends StatefulWidget {
  final String dateKey;
  const _DayNotesSheet({required this.dateKey});
  @override
  State<_DayNotesSheet> createState() => _DayNotesSheetState();
}

class _DayNotesSheetState extends State<_DayNotesSheet> {
  Future<void> _add() async {
    final title = TextEditingController();
    final text = TextEditingController();
    NoteType type = NoteType.birthday;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Новая заметка'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                    labelText: 'Название', hintText: 'Например: День рождения мамы'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<NoteType>(
                value: type,
                decoration: const InputDecoration(labelText: 'Тип'),
                items: const [
                  DropdownMenuItem(value: NoteType.birthday, child: Text('🎂 День рождения')),
                  DropdownMenuItem(value: NoteType.event, child: Text('📅 Событие')),
                  DropdownMenuItem(value: NoteType.other, child: Text('📝 Другое')),
                ],
                onChanged: (v) => setD(() => type = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: text,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Описание (необязательно)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Сохранить')),
          ],
        ),
      ),
    );
    if (ok == true && title.text.trim().isNotEmpty) {
      await NotesStorage.save(Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dateKey: widget.dateKey,
        type: type,
        title: title.text.trim(),
        text: text.text.trim(),
      ));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = NotesStorage.of(widget.dateKey);
    return Padding(
      padding: EdgeInsets.only(
          left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.dateKey,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          if (notes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Заметок пока нет', textAlign: TextAlign.center),
            )
          else
            ...notes.map((n) => Card(
                  child: ListTile(
                    leading: Icon(switch (n.type) {
                      NoteType.birthday => Icons.cake_outlined,
                      NoteType.event => Icons.event_outlined,
                      NoteType.other => Icons.notes,
                    }),
                    title: Text(n.title),
                    subtitle: n.text.isEmpty ? null : Text(n.text),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await NotesStorage.remove(widget.dateKey, n.id);
                        setState(() {});
                      },
                    ),
                  ),
                )),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add),
            label: const Text('Добавить заметку'),
          ),
        ],
      ),
    );
  }
}