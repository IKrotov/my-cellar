import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/network/cellars_api.dart';
import '../../../../core/network/dto/cellar_dto.dart';
import '../../../../core/repository/cellar_repository.dart';
import '../../../../core/storage/current_cellar_storage.dart';
import '../../../../generated/l10n/app_localizations.dart';

/// Всплывающее окно создания погреба (барьер не снимается — нужно создать или отменить).
/// Сначала сохраняем в локальную БД (pending), затем в фоне отправляем на бэкенд и при успехе помечаем синхронизацию.
/// [isFirstCellar]: true — ждём ответ API и вызываем [onCreated] (экран выбора первого погреба); false — сразу закрываем и вызываем [onAddedPending].
class CreateCellarDialog extends StatefulWidget {
  const CreateCellarDialog({
    super.key,
    required this.authService,
    required this.cellarRepository,
    this.isFirstCellar = false,
    this.onCreated,
    this.onAddedPending,
  });

  final AuthService authService;
  final CellarRepository cellarRepository;
  final bool isFirstCellar;
  final void Function(CurrentCellar cellar)? onCreated;
  final void Function(int localId, String name)? onAddedPending;

  @override
  State<CreateCellarDialog> createState() => _CreateCellarDialogState();
}

class _CreateCellarDialogState extends State<CreateCellarDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    final name = _nameController.text.trim();
    try {
      final localId = await widget.cellarRepository.insert(
        name: name,
        syncStatus: 'pending',
      );
      if (!mounted) return;

      if (widget.isFirstCellar && widget.onCreated != null) {
        final dio = widget.authService.getApiClient().dio;
        final api = CellarsApi(dio);
        final created = await api.create(CreateCellarRequestDto(name: name));
        if (!mounted) return;
        await widget.cellarRepository.update(
          localId,
          serverId: created.id,
          syncStatus: 'synced',
          updatedAt: created.updatedAt,
        );
        final cellar = CurrentCellar(id: created.id!, name: created.name);
        await CurrentCellarStorage().save(cellar);
        widget.onCreated!(cellar);
        if (!mounted) return;
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(content: Text('${created.name}')));
      } else if (widget.onAddedPending != null) {
        widget.onAddedPending!(localId, name);
        if (!mounted) return;
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(content: Text(name)));
      } else {
        setState(() => _sending = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.newCellar),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.name,
            border: const OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.nameRequired;
            }
            return null;
          },
        ),
      ),
      actions: [
        FilledButton(
          onPressed: _sending ? null : _onCreate,
          child: _sending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }
}
