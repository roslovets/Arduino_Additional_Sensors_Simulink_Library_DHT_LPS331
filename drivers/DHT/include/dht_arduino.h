#ifndef _DHT_ARDUINO_H_
#define _DHT_ARDUINO_H_
#include "rtwtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

void setDHT(uint8_T pin, uint8_T type);
float readTemp();
float readTempF();
float readHumidity();
float computeHeatIndex(float t, float h);
float computeHeatIndexF(float f, float h);

#ifdef __cplusplus
}
#endif
#endif