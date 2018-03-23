import 'package:discount_machine/commons/log.dart';
import 'package:flutter_flux/flutter_flux.dart';

class LoggingStore extends Store with LoggerMiddleware {
  LoggingStore() : super()   {
    listen((store) {
      logger.finest('triggered $store');
    }, onDone: () => logger.fine('onDone'), onError: (e) => logger.warning('Store Error', e));
  }}
