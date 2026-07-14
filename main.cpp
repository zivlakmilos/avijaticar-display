#include <QGuiApplication>
#include <QQmlApplicationEngine>

#ifdef __ANDROID__
#include <QtWebView>
#endif // __ANDROID__

int main(int argc, char *argv[])
{
  qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

#ifdef __ANDROID__
  QtWebView::initialize();
#endif // __ANDROID__

  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); },
      Qt::QueuedConnection);
  engine.loadFromModule("avijaticarui", "Main");

  return QGuiApplication::exec();
}
