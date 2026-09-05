import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Numpad 0-9 plus hapus.
///
/// Tanpa tombol kirim: tekan angka = tercatat dan langsung lanjut. Tombol
/// hapus sengaja dipisah dari deretan angka dan diberi warna berbeda supaya
/// tidak tertekan saat mengejar tempo.
class Numpad extends StatelessWidget {
  const Numpad({super.key, required this.onDigit, required this.onDelete});

  final ValueChanged<int> onDigit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PauliSizes.gutter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in const [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  for (final d in row) ...[
                    Expanded(child: _Key(label: '$d', onTap: () => onDigit(d))),
                    if (d != row.last) const SizedBox(width: 10),
                  ],
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: _Key(
                  icon: Icons.backspace_outlined,
                  muted: true,
                  onTap: onDelete,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _Key(label: '0', onTap: () => onDigit(0))),
            ],
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({this.label, this.icon, required this.onTap, this.muted = false});

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: muted ? const Color(0xFFE6E0D0) : PauliColors.card,
      borderRadius: BorderRadius.circular(PauliSizes.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(PauliSizes.radius),
        // Tanpa jeda percikan: di kecepatan satu ketukan per detik, animasi
        // tekan yang menunggu justru terasa seperti aplikasi ketinggalan.
        onTap: onTap,
        child: Container(
          height: 78,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PauliSizes.radius),
            border: Border.all(color: PauliColors.line),
          ),
          child: icon != null
              ? Icon(icon, size: 26, color: PauliColors.ink)
              : Text(
                  label!,
                  style: mono(size: 30, weight: FontWeight.w500)
                      .copyWith(color: PauliColors.ink),
                ),
        ),
      ),
    );
  }
}
