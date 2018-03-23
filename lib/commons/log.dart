import 'package:logging/logging.dart';

final Function setupLogger = ({Level level = Level.FINE}) {
  Logger.root.level = level;

  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.time} ${rec.level.name} ${rec.loggerName}: ${rec.message}');
    //TODO print error and stacktrace when available
  });
};

class LoggerMiddleware {
  static Logger _logger;

  Logger get logger =>
      _logger == null ? _logger = new Logger(this.runtimeType.toString()) : _logger;
}
