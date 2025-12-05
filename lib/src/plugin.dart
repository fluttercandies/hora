import 'package:meta/meta.dart';

import 'hora.dart';

/// Base class for Hora plugins.
///
/// Plugins extend [Hora] functionality without modifying the core class.
/// Use [Hora.use] to register plugins globally.
///
/// ## Creating a Plugin
///
/// ```dart
/// class MyPlugin extends HoraPlugin {
///   const MyPlugin();
///
///   @override
///   String get name => 'myPlugin';
///
///   @override
///   void install() {
///     // Register extensions or modify behavior
///   }
/// }
///
/// // Usage
/// Hora.use(const MyPlugin());
/// ```
@immutable
abstract class HoraPlugin {
  const HoraPlugin();

  /// The unique name of this plugin.
  String get name;

  /// Called when the plugin is registered.
  void install() {}

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HoraPlugin && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// Registry for plugin-provided extensions on [Hora].
///
/// Plugins can register extension methods that can be called via [Hora].
class HoraPluginRegistry {
  HoraPluginRegistry._();

  static final Map<String, dynamic Function(Hora, List<dynamic>)> _extensions =
      {};

  /// Registers an extension method.
  static void registerExtension(
    String name,
    dynamic Function(Hora hora, List<dynamic> args) handler,
  ) {
    _extensions[name] = handler;
  }

  /// Checks if an extension is registered.
  static bool hasExtension(String name) => _extensions.containsKey(name);

  /// Calls an extension method.
  static dynamic callExtension(
    Hora hora,
    String name, [
    List<dynamic> args = const [],
  ]) {
    final handler = _extensions[name];
    if (handler == null) {
      throw UnsupportedError('Plugin extension "$name" not found');
    }
    return handler(hora, args);
  }
}
