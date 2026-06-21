import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../providers/app_providers.dart';

void showAddSpeciesSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _AddSpeciesSheet(),
  );
}

class _AddSpeciesSheet extends ConsumerStatefulWidget {
  const _AddSpeciesSheet();

  @override
  ConsumerState<_AddSpeciesSheet> createState() => _AddSpeciesSheetState();
}

class _AddSpeciesSheetState extends ConsumerState<_AddSpeciesSheet> {
  final _formKey = GlobalKey<FormState>();
  final _commonNameCtrl = TextEditingController();
  final _chineseNameCtrl = TextEditingController();
  final _scientificNameCtrl = TextEditingController();
  String? _selectedFamily;
  bool _saving = false;

  @override
  void dispose() {
    _commonNameCtrl.dispose();
    _chineseNameCtrl.dispose();
    _scientificNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(speciesListProvider.notifier).addCustom(
            commonName: _commonNameCtrl.text.trim(),
            chineseName: _chineseNameCtrl.text.trim().isEmpty
                ? null
                : _chineseNameCtrl.text.trim(),
            scientificName: _scientificNameCtrl.text.trim().isEmpty
                ? null
                : _scientificNameCtrl.text.trim(),
            familyGroup: _selectedFamily,
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appStringsProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(s.addSpeciesTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _commonNameCtrl,
              decoration: InputDecoration(labelText: s.englishNameLabel),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? s.required : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _chineseNameCtrl,
              decoration: InputDecoration(labelText: s.chineseNameLabel),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _scientificNameCtrl,
              decoration: InputDecoration(
                  labelText: s.scientificNameLabel,
                  hintText: s.scientificNameHint),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedFamily,
              decoration: InputDecoration(labelText: s.familyGroupLabel),
              hint: Text(s.selectFamily),
              items: [
                ...kFamilyOrder.map((f) => DropdownMenuItem(
                      value: f,
                      child: Text('${kFamilyChineseNames[f] ?? f}  ·  $f'),
                    )),
                const DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() => _selectedFamily = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(s.addToJournal, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
