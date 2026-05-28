// lib/utils/label_utils.dart

String cicloLabel(int n) {
  const suffixes = {5: 'to', 6: 'to', 7: 'mo', 8: 'vo', 9: 'no', 10: 'mo'};
  return '$n${suffixes[n] ?? 'mo'} ciclo';
}
