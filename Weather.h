#ifndef _WEATHER_H_
#define _WEATHER_H_

#include <QJsonArray>
#include <QObject>
#include <QTimer>
#include <QVariantList>

class QNetworkAccessManager;
class QNetworkReply;

class Weather : public QObject
{
  Q_OBJECT

  Q_PROPERTY(QVariantList airports READ airports NOTIFY weatherUpdated)

public:
  Weather(QObject *parent = nullptr);
  ~Weather(void);

  QVariantList airports(void) const;

private:
  void setupHandlers(void);

  QNetworkAccessManager *m_networkManager;
  QTimer *m_refreshTimer;
  QJsonArray m_metarData;
  QJsonArray m_tafData;
  bool m_metarReceived;
  bool m_tafReceived;

public slots:
  void getWeather(void);
  void startAutoRefresh(int intervalMs = 60000);
  void stopAutoRefresh(void);

private slots:
  void handleNetworkReply(QNetworkReply *reply);

signals:
  void weatherUpdated(void);
};

#endif // _WEATHER_H_
