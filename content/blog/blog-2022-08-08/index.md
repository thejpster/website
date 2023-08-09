+++
title = "Rev 1.0.0 is alive!"
date = "2022-08-08"
+++


The latest rev 1.0.0 boards arrived today. I worked through a test procedure carefully:

1. Visual Inspection
2. Load through-hole components (and VGA buffer JLCPCB didn't have in stock), but leaving out the PSU
3. 12V input at 40mA current limit showed no issues
4. Manually apply 3.3VP to R1303 and check DC_ON pin of PSU header goes to 5.6V
5. Flash STM32 and check we can power on and power off the board (no PSU fitted still. with the button, and that the power LED works
6. Fit the PSU module, check 5.0V and 3.3V rails OK (5.03V and 3.29V)
7. Fit the Raspberry Pi Pico and check the VGA output

Still to do:

1. Talk to the CODEC over I2C and do audio loop-back tests
2. Talk to the MCP23S18 over SPI and drive the debug LEDs
3. Talk to an expansion card
4. Talk to the SD card
5. Check the PS/2 ports work
