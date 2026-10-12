import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

// "Versão 1.0.0+3", pequeno, para o rodapé da tela de Ajustes. Quem testa e quem reporta
// um problema precisa saber a versão sem abrir o log.
class AppVersionLabel extends StatefulWidget {
  const AppVersionLabel({super.key, this.style});

  final TextStyle? style;

  @override
  State<AppVersionLabel> createState() => _AppVersionLabelState();
}

class _AppVersionLabelState extends State<AppVersionLabel> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (!mounted) return;
      setState(() => _version = 'Versão ${info.version}+${info.buildNumber}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _version,
        style: widget.style ??
            TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
    );
  }
}
