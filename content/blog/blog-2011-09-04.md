+++
title="L293 Driver"
date="2011-09-04"
+++

Just put some more code on github. I'm still not entirely sure what I'm doing with git, or why I have to 'add' code whenever I change it, even if it's already been added.

See http://github.com/thejpster/L293

I'll take a video of the code running soon, but here it is.

```cpp
/* Simple MCP23S17 demonstration */

/* Supplied with Arduino IDE */
#include <SPI.h>

// Mcp23s17 library available from https://github.com/thejpster/Mcp23s17
#include <Mcp23s17.h>

// L293 point driving library available from https://github.com/thejpster/L293
#include <l293.h>

// Wire up the SPI Interface common lines:
// SPI_MOSI   11 //arduino <-> SPI Master Out Slave In   -> SI  (Pin 13 on MCP23S17 DIP)
// SPI_MISO    12 //arduino <-> SPI Master In Slave Out   -> SO  (Pin 14 on MCP23S17 DIP)
// SPI_CLOCK  13 //arduino <-> SPI Slave Clock Input     -> SCK (Pin 12 on MCP23S17 DIP)

// Then choose any other free pin as the Slave Select (pin 10 if the default but doesnt have to be)
#define MCP23S17_SLAVE_SELECT_PIN  9 //arduino <-> SPI Slave Select -> CS  (Pin 11 on MCP23S17 DIP)

// Instantiate a single Mcp23s17 object
MCP23S17 io_chip = MCP23S17( MCP23S17_SLAVE_SELECT_PIN /* CS */, 0x0 /* Tie A0/A1/A2 low */);

// L293 drivers
L293 points[2] = {
  L293(&io_chip, MCP23S17::GPIO_B0 /* Strobe */, MCP23S17::GPIO_A0 /* Left */, MCP23S17::GPIO_A1 /* Right */),
  L293(&io_chip, MCP23S17::GPIO_B1 /* Strobe */, MCP23S17::GPIO_A0 /* Left */, MCP23S17::GPIO_A1 /* Right */)
};

void setup()
{
  // Setup the serial port so we can see some debug
  Serial.begin(115200);
  Serial.print("Starting...");

  Serial.println("Started.");
}

void loop()
{
  // send data only when you receive data:
  if (Serial.available() > 0)
  {
    char incomingByte;
    // read the incoming byte:
    incomingByte = Serial.read();
    switch(incomingByte)
    {
    case '1':
      Serial.println("Point 1 Left");
      points[0].strobeLeft();
      break;  
    case '2':
      Serial.println("Point 1 Right");
      points[0].strobeRight();
      break;  
    case '3':
      Serial.println("Point 2 Left");
      points[1].strobeLeft();
      break;  
    case '4':
      Serial.println("Point 2 Right");
      points[1].strobeRight();
      break;  
    default:
      break;    
    }
  }
}
```
