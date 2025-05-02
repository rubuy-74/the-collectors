import 'package:flutter/material.dart';

class ParticipantSplit {
  final String id; 
  final String name;
  final String avatarUrl;
  final double amount;

  ParticipantSplit({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.amount,
  });
}

class SplitBillDialog extends StatefulWidget {
  final String title;
  final double totalAmount;
  final List<ParticipantSplit> initialParticipants;

  const SplitBillDialog({
    super.key,
    required this.title,
    required this.totalAmount,
    required this.initialParticipants,
  });

  @override
  State<SplitBillDialog> createState() => _SplitBillDialogState();
}

class _SplitBillDialogState extends State<SplitBillDialog> {
  late List<ParticipantSplit> participants;

  @override
  void initState() {
    super.initState();
    participants = List.from(widget.initialParticipants); 
  }

  void _removeParticipant(String id) {
    setState(() {
      participants.removeWhere((p) => p.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTotal = widget.totalAmount.toStringAsFixed(2).replaceAll('.', ',');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Total ${formattedTotal}€',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 5.0),
            const Divider(),
            const SizedBox(height: 10.0),

            if (participants.isEmpty)
              const Text('Nenhum participante.', textAlign: TextAlign.center)
            else
              ListView.builder(
                shrinkWrap: true, 
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final participant = participants[index];
                  return _ParticipantRow(
                    participant: participant,
                    onRemove: () => _removeParticipant(participant.id),
                  );
                },
              ),
             const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final ParticipantSplit participant;
  final VoidCallback onRemove;

  const _ParticipantRow({
    required this.participant,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    String formattedAmount = participant.amount.toStringAsFixed(2).replaceAll('.', ',');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(participant.avatarUrl), 
            backgroundColor: Colors.grey[300], 
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              participant.name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 12.0),
          Text(
            '${formattedAmount}€',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onRemove,
            tooltip: 'Remover ${participant.name}',
            visualDensity: VisualDensity.compact, 
            padding: EdgeInsets.zero, 
            constraints: const BoxConstraints(), 
          ),
        ],
      ),
    );
  }
}
