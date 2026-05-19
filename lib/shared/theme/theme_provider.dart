import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  final ThemeMode tema;
  final bool notificacoesAtivas;
  final bool tocarSomAoCair;

  const UserPrefs({
    this.tema = ThemeMode.dark,
    this.notificacoesAtivas = true,
    this.tocarSomAoCair = false,
  });

  UserPrefs copyWith({
    ThemeMode? tema,
    bool? notificacoesAtivas,
    bool? tocarSomAoCair,
  }) =>
      UserPrefs(
        tema: tema ?? this.tema,
        notificacoesAtivas: notificacoesAtivas ?? this.notificacoesAtivas,
        tocarSomAoCair: tocarSomAoCair ?? this.tocarSomAoCair,
      );
}

final userPrefsProvider =
    StateNotifierProvider<UserPrefsNotifier, UserPrefs>((ref) {
  return UserPrefsNotifier();
});

class UserPrefsNotifier extends StateNotifier<UserPrefs> {
  UserPrefsNotifier() : super(const UserPrefs()) {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = UserPrefs(
      tema: ThemeMode.values[p.getInt('tema') ?? ThemeMode.dark.index],
      notificacoesAtivas: p.getBool('notificacoes') ?? true,
      tocarSomAoCair: p.getBool('som_cair') ?? false,
    );
  }

  Future<void> setTema(ThemeMode tema) async {
    state = state.copyWith(tema: tema);
    final p = await SharedPreferences.getInstance();
    await p.setInt('tema', tema.index);
  }

  Future<void> setNotificacoes(bool ativo) async {
    state = state.copyWith(notificacoesAtivas: ativo);
    final p = await SharedPreferences.getInstance();
    await p.setBool('notificacoes', ativo);
  }

  Future<void> setTocarSomAoCair(bool ativo) async {
    state = state.copyWith(tocarSomAoCair: ativo);
    final p = await SharedPreferences.getInstance();
    await p.setBool('som_cair', ativo);
  }
}
