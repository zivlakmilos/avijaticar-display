#include "Weather.h"

#include <QtCore>
#include <QtNetwork>

Weather::Weather(QObject *parent) :
    QObject(parent),
    m_networkManager(new QNetworkAccessManager(this)),
    m_refreshTimer(new QTimer(this)),
    m_metarReceived(false),
    m_tafReceived(false)
{
  setupHandlers();
  connect(m_refreshTimer, &QTimer::timeout, this, &Weather::getWeather);
}

Weather::~Weather(void)
{
}

void Weather::setupHandlers(void)
{
  connect(m_networkManager, &QNetworkAccessManager::finished, this, &Weather::handleNetworkReply);
}

void Weather::handleNetworkReply(QNetworkReply *reply)
{
  if (reply->error())
  {
    qDebug() << reply->errorString();
    reply->deleteLater();
    return;
  }

  QString endpoint = reply->property("endpoint").toString();
  QByteArray data = reply->readAll();
  QJsonDocument doc = QJsonDocument::fromJson(data);

  if (!doc.isArray())
  {
    qDebug() << "Invalid JSON response for" << endpoint;
    reply->deleteLater();
    return;
  }

  if (endpoint == "metar")
  {
    m_metarData = doc.array();
    m_metarReceived = true;
  }
  else if (endpoint == "taf")
  {
    m_tafData = doc.array();
    m_tafReceived = true;
  }

  reply->deleteLater();

  if (m_metarReceived && m_tafReceived)
  {
    emit weatherUpdated();
  }
}

void Weather::getWeather(void)
{
  m_metarReceived = false;
  m_tafReceived = false;
  m_metarData = QJsonArray();
  m_tafData = QJsonArray();

  QString metarUrl = "https://aviationweather.gov/api/data/metar?ids=LYBT,LYBE,LDOS&format=json";
  QString tafUrl = "https://aviationweather.gov/api/data/taf?ids=LYBT,LYBE,LDOS&format=json";

  QNetworkRequest metarReq(metarUrl);
  QNetworkReply *metarReply = m_networkManager->get(metarReq);
  metarReply->setProperty("endpoint", "metar");

  QNetworkRequest tafReq(tafUrl);
  QNetworkReply *tafReply = m_networkManager->get(tafReq);
  tafReply->setProperty("endpoint", "taf");
}

QVariantList Weather::airports(void) const
{
  QVariantList result;

  QMap<QString, QVariantMap> combined;

  for (const QJsonValue &val : m_metarData)
  {
    QJsonObject obj = val.toObject();
    QString icao = obj["icaoId"].toString();

    QVariantMap airport;
    airport["icaoId"] = icao;
    airport["metar"] = obj["rawOb"].toString();

    combined[icao] = airport;
  }

  for (const QJsonValue &val : m_tafData)
  {
    QJsonObject obj = val.toObject();
    QString icao = obj["icaoId"].toString();

    if (combined.contains(icao))
    {
      combined[icao]["taf"] = obj["rawTAF"].toString();
    }
    else
    {
      QVariantMap airport;
      airport["icaoId"] = icao;
      airport["taf"] = obj["rawTAF"].toString();
      combined[icao] = airport;
    }
  }

  for (const QVariantMap &airport : combined.values())
  {
    result.append(airport);
  }

  return result;
}

void Weather::startAutoRefresh(int intervalMs)
{
  m_refreshTimer->start(intervalMs);
}

void Weather::stopAutoRefresh(void)
{
  m_refreshTimer->stop();
}
