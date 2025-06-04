import 'dart:convert';
import 'dart:io';

import 'package:nyxx/nyxx.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../core/data/models/activity_data.dart';
import '../core/utils/services.dart';

class ApiServer {
  ApiServer({required Services services}) : _services = services;

  final Services _services;
  HttpServer? _server;

  Future<void> start() async {
    final port = int.parse(Platform.environment['API_PORT'] ?? '8080');

    final router = Router()
      ..get('/health', _health)
      ..get('/activities', _activities)
      ..post('/activities', _addActivity)
      ..delete('/activities/<name>', _removeActivity)
      ..get('/settings', _settings)
      ..put('/settings/lfg_channel', _setLfgChannel)
      ..put('/settings/promotes_channel', _setPromotesChannel);

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(_checkPermissions())
        .addHandler(router);

    _server = await serve(handler, InternetAddress.anyIPv4, port);
  }

  Middleware _checkPermissions() {
    return (inner) {
      return (request) async {
        final id = request.headers['X-User-Id'];
        if (id == null) return Response.forbidden('Missing user');
        try {
          final member = await _services.bot.guilds[_services.config.server]
              .members
              .get(Snowflake(int.parse(id)));
          if (!member.permissions.hasPermission(Permissions.manageRoles)) {
            return Response.forbidden('Forbidden');
          }
        } catch (_) {
          return Response.forbidden('Forbidden');
        }
        return inner(request);
      };
    };
  }

  Response _health(Request request) => Response.ok('ok');

  Future<Response> _activities(Request request) async {
    final acts = await _services.settings.getActivities();
    final data = [
      for (final a in acts)
        {
          'name': a.name,
          'maxMembers': a.maxMembers,
          'banner': a.bannerUrl,
          'enabled': a.enabled,
          if (a.roles != null)
            'roles': [
              for (final r in a.roles!) {'role': r.role, 'qty': r.quantity}
            ]
        }
    ];
    return Response.ok(jsonEncode(data), headers: {'Content-Type': 'application/json'});
  }

  Future<Response> _addActivity(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    final roles = (json['roles'] as List?)
        ?.map((e) => ActivityRole(role: e['role'], quantity: e['qty']))
        .toList();
    await _services.settings.addActivity(
      ActivityData(
        name: json['name'],
        maxMembers: json['maxMembers'],
        bannerUrl: json['banner'],
        roles: roles,
        enabled: json['enabled'] ?? true,
      ),
    );
    return Response.ok('added');
  }

  Future<Response> _removeActivity(Request request, String name) async {
    await _services.settings.removeActivity(name);
    return Response.ok('removed');
  }

  Future<Response> _settings(Request request) async {
    final lfg = await _services.settings.getLFGChannel();
    final promo = await _services.settings.getPromotesChannel();
    final tz = await _services.settings.getTimezones();
    final data = {'lfg_channel': lfg, 'promotes_channel': promo, 'timezones': tz};
    return Response.ok(jsonEncode(data), headers: {'Content-Type': 'application/json'});
  }

  Future<Response> _setLfgChannel(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    await _services.settings.updateLFGChannel(json['channel']);
    return Response.ok('ok');
  }

  Future<Response> _setPromotesChannel(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    await _services.settings.updatePromotesChannel(json['channel']);
    return Response.ok('ok');
  }
}
