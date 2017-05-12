#ifndef _LPS331_ARDUINO_H_
#define _LPS331_ARDUINO_H_
#include "rtwtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

void setLPS();
float readPressureMillibars();
float readPressureInchesHg();
float pressureToAltitudeMeters(float pressure);
float pressureToAltitudeFeet(float pressure);
float readTemperatureC();
float readTemperatureF();

#ifdef __cplusplus
}
#endif
#endif