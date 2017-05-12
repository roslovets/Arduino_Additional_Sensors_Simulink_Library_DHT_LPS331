#include <Arduino.h>
#include "lps331_arduino.h"
#include <LPS331.h>
#include <Wire.h>

/*
 * loop
 *
 * Code to be executed repeatedly.
 */

LPS331 ps;

extern "C" void setLPS() {
    Wire.begin();
    ps.init();
    ps.enableDefault();
}

extern "C" float readPressureMillibars() {
        return ps.readPressureMillibars();
}

extern "C" float readPressureInchesHg() {
        return ps.readPressureInchesHg();
};

extern "C" float pressureToAltitudeMeters(float pressure) {
        return ps.pressureToAltitudeMeters(pressure);
}

extern "C" float pressureToAltitudeFeet(float pressure) {
        return ps.pressureToAltitudeFeet(pressure);
}

extern "C" float readTemperatureC() {
        return ps.readTemperatureC();
}

extern "C" float readTemperatureF() {
        return ps.readTemperatureF();
}