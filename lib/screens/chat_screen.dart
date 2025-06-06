import 'package:flutter/material.dart';
import 'package:projeto_final_rotina_estudos/services/openrouter_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String resposta = '';
  bool carregando = false;

  void enviarPergunta() async {
    final pergunta = _controller.text.trim();
    if (pergunta.isEmpty) return;

    setState(() {
      carregando = true;
      resposta = '';
    });

    final respostaIA = await OpenRouterService.getResposta(pergunta);

    setState(() {
      carregando = false;
      resposta = respostaIA;
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Scaffold(
      appBar: AppBar(
        title: const Text("SAIM - Chat IA"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Digite sua pergunta...",
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: const BorderSide(color: Colors.lightBlueAccent),
                ),
              ),
              onSubmitted: (_) => enviarPergunta(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: carregando ? null : enviarPergunta,
                icon: const Icon(Icons.send),
                label: const Text("Enviar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: carregando
                    ? const CircularProgressIndicator(color: Colors.lightBlueAccent)
                    : resposta.isNotEmpty
                        ? SingleChildScrollView(
                            child: Text(
                              resposta,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Faça uma pergunta para começar a conversa.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}