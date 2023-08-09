+++
title = "Code"
date = "2011-08-02"
+++


You can get my modified MCP23S17 library from Github: https://github.com/thejpster/Mcp23s17

My four-led twinkling app is:

```cpp
/* Simple MCP23S17 demonstration */

/* Supplied with Arduino IDE */
#include <arduino.h>

// Mcp23s17 library available from https://github.com/dreamcat4/Mcp23s17
#include <mcp23s17.h>

// Wire up the SPI Interface common lines:
// #define SPI_MOSI             11 //arduino   <->   SPI Master Out Slave In   -> SI  (Pin 13 on MCP23S17 DIP)
// #define SPI_MISO             12 //arduino   <->   SPI Master In Slave Out   -> SO  (Pin 14 on MCP23S17 DIP)
// #define SPI_CLOCK            13 //arduino   <->   SPI Slave Clock Input     -> SCK (Pin 12 on MCP23S17 DIP)

// Then choose any other free pin as the Slave Select (pin 10 if the default but doesnt have to be)
#define MCP23S17_SLAVE_SELECT_PIN  9 //arduino   <->   SPI Slave Select           -> CS  (Pin 11 on MCP23S17 DIP)
#define MCP23S17_RESET_PIN         8
// SINGLE DEVICE
// Instantiate a single Mcp23s17 object
MCP23S17 Mcp23s17 = MCP23S17( MCP23S17_SLAVE_SELECT_PIN );

// MULTIPLE DEVICES
// Up to 8 MCP23S17 devices can share the same SPI bus and slave select pins.
// Assign each chip a unique 3-bit device address (by setting the A2,A1,A0 pins)
// Then below, device address is optional 2nd parameter to the constructor fn...
// MCP23S17 Mcp23s17_0 = MCP23S17(MCP23S17_SLAVE_SELECT_PIN,0x0);
// ...
// MCP23S17 Mcp23s17_7 = MCP23S17(MCP23S17_SLAVE_SELECT_PIN,0x7);

void setup()
{
    // Setup the serial port so we can see some debug
    Serial.begin(115200);
    Serial.print("Starting...");

    pinMode(MCP23S17_RESET_PIN, OUTPUT);
    digitalWrite(MCP23S17_RESET_PIN, HIGH);
    delay(250);
    digitalWrite(MCP23S17_RESET_PIN, LOW);
    delay(250);
    digitalWrite(MCP23S17_RESET_PIN, HIGH);

    // Setup the SPI interface (default clock rate, etc)
    SPI.begin();

    // Set all pins to be outputs (by default they are all inputs)
    Mcp23s17.pinMode(OUTPUT);

    Serial.println("Started.");
}

// Cycle the output lines
long timeoutInterval = 250;
long previous = 0;
uint16_t counter = 0x0100;

void timeout()
{
    Mcp23s17.port(counter);
    counter <<= 1;
    if (counter == 0x1000)
    {
        counter = 0x0100;
    }
}  

void loop()
{
    // handle timeout function, if any
    long now = millis();
    if ( (now - previous) > timeoutInterval )
    {
        timeout();
        previous = now;
    }
    // Loop.
}
```