import 'package:flutter/material.dart';
import 'package:arabic_verb_final/core/conjugation/verb_root.dart';
import 'package:arabic_verb_final/core/conjugation/act_part.dart';
import 'package:arabic_verb_final/core/conjugation/pas_part.dart';
import 'package:arabic_verb_final/core/conjugation/place_time.dart';
import 'package:arabic_verb_final/core/conjugation/state_name.dart';
import 'package:arabic_verb_final/core/conjugation/once_name.dart';
import 'package:arabic_verb_final/core/conjugation/pre_post_processing.dart';

class ConjugationScreen extends StatefulWidget {
  const ConjugationScreen({Key? key}) : super(key: key);

  @override
  _ConjugationScreenState createState() => _ConjugationScreenState();
}

class _ConjugationScreenState extends State<ConjugationScreen> {
  final TextEditingController _verbController = TextEditingController();
  final VerbRoot _verbRoot = VerbRoot();
  final ActPart _actPart = ActPart();
  final PasPart _pasPart = PasPart();
  final PlaceTime _placeTime = PlaceTime();
  final StateName _stateName = StateName();
  final OnceName _onceName = OnceName();
  final PrePostProcessing _prePostProcessing = PrePostProcessing();

  String _verbRootResult = '';
  String _activeParticipleResult = '';
  String _passiveParticipleResult = '';
  String _placeTimeResult = '';
  String _stateNameResult = '';
  String _onceNameResult = '';

  void _conjugateVerb() {
    final verb = _verbController.text.trim();
    if (verb.isEmpty) return;

    setState(() {
      _verbRootResult = _verbRoot.getRoot(verb);
      _activeParticipleResult = _actPart.activeParticiple(verb);
      _passiveParticipleResult = _pasPart.passiveParticiple(verb);
      _placeTimeResult = _placeTime.place(verb);
      _stateNameResult = _stateName.state(verb);
      _onceNameResult = _onceName.once(verb);
    });
  }

  @override
  void dispose() {
    _verbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabic Verb Conjugator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _verbController,
              decoration: InputDecoration(
                labelText: 'Enter Arabic verb',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _verbController.clear();
                    setState(() {
                      _verbRootResult = '';
                      _activeParticipleResult = '';
                      _passiveParticipleResult = '';
                      _placeTimeResult = '';
                      _stateNameResult = '';
                      _onceNameResult = '';
                    });
                  },
                ),
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _conjugateVerb,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Conjugate', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 30),
            if (_verbRootResult.isNotEmpty) ...[
              _buildResultCard('Verb Root', _verbRootResult),
              const SizedBox(height: 16),
              _buildResultCard('Active Participle', _activeParticipleResult),
              const SizedBox(height: 16),
              _buildResultCard('Passive Participle', _passiveParticipleResult),
              const SizedBox(height: 16),
              _buildResultCard('Place/Time', _placeTimeResult),
              const SizedBox(height: 16),
              _buildResultCard('State Name', _stateNameResult),
              const SizedBox(height: 16),
              _buildResultCard('Once Name', _onceNameResult),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String content) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'Arial',
                height: 1.5,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}