library dart_force_mvc_lib;

import 'dart:async';
import 'dart:mirrors';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http_server/http_server.dart' as http_server;
import 'package:route/server.dart' show Router, UrlPattern;
import 'package:logging/logging.dart' show Logger, Level, LogRecord;

import 'package:path/path.dart' show normalize;

import 'package:mustache4dart/mustache4dart.dart';

import 'package:forcemirrors/force_mirrors.dart';
import 'package:wired/wired.dart';

part 'server/web_application.dart';
part 'server/simple_web_server.dart';
part 'server/mvc_typedefs.dart';
part 'server/request_method.dart';
part 'server/model.dart';
part 'server/force_request.dart';
part 'server/registry.dart';
part 'server/handler_interceptor.dart';
part 'server/interceptors_collection.dart';
part 'server/path_analyzer.dart';
part 'server/serving_files.dart';
part 'server/response_hooks.dart';
part 'server/http_request_streamer.dart';
part 'server/serving_assistent.dart';

part 'i18n/locale.dart';
part 'i18n/locale_resolver.dart';
part 'i18n/accept_header_locale_resolver.dart';
part 'i18n/default_locale_resolver.dart';
part 'i18n/fixed_locale_resolver.dart';
part 'i18n/cookie_locale_resolver.dart';

part 'manager/cookie_holder_manager.dart';

// security
part 'security/security_context_holder.dart';
part 'security/security_strategy.dart';
part 'security/no_security_strategy.dart';

// render
part 'render/view_render.dart';
part 'render/mustache_render.dart';

part 'annotations/metadata.dart';
part 'annotations/helpers.dart';

// exception handling
part 'error/handler_exception_resolver.dart';
part 'error/simple_exception_resolver.dart';

// usefull mixins 
part 'mixins/jsonify.dart';