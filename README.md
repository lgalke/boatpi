# Boat Navigation System

A Raspberry Pi Boat Navigation System, based on the guide from Martin Loschwith [^1].

## Hardware  

### Hardware Requirements

- Raspberry Pi
- Power Supply
- [Mouse and Keyboard]
- SD card with Raspbian installed
- GPS Module
- Display (preferably without additional power demands)


### Hardware Installation

1. Insert SD card into Raspberry Pi.
1. Connect mouse, keyboard and display.
1. Connect power supply.
1. Run `sudo raspi-config`, navigate to *Advanced Options > Resolution* and set resolution according to your display (720p is recommended).
1. Run `sudo reboot`, to let changes within `raspi-config` take effect.

When other instructions are given by the display manufacturer, these need to be considered as well.

## Software

### Installing GPS Requirements

Make sure your system is up-to-date `sudo apt-get update && sudo apt-get upgrade`.
Install the `gpsd` GPS daemon itself:

```sh
sudo apt-get install gpsd gpsd-clients python-gps
```

Change the service's configuration by editing the `/etc/default/gpsd` file.
Insert the path for the interface (i.e. `/dev/ttyACM0`) of the GPS module into
the `DEVICES` line. In the same file, add `-b` to `GPSD_OPTIONS`.
Restart the `gpsd` service via `service gpsd restart`.
Test the set-up by issuing `cgps` in a command prompt.


### Setting up OpenCPN

The OpenCPN navigation software can be installed on the Raspberry Pi with the following steps [^4]:

1. Edit the package sources via `sudo nano /etc/apt/sources.list`.
1. Add the line `deb http://ppa.launchpad.net/opencpn/opencpn/ubuntu/ trusty main`. Make sure to save the changes.
1. Retrieve the key from the keyserver by issuing `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C865EB40` at a command prompt.
1. Update the package list via `sudo apt-get update`.
1. Install the `opencpn` software itself by `sudo apt-get install opencpn`.
1. *optional*, if desired, install available OpenCPN plugins `sudo apt-get install opencpn*`.


### Supported Chart Formats

OpenCPN is compatible with the following chart formats[^2]:

- Worldwide standard S56 and encrypted S63 vector chart.
- BSB v3 and earlier raster charts.
- CM93 vector charts with per cell offset corrections
- ENCs, distributed by o-charts.org [^3] for selected regions

## Fine-tuning

### Power Consumption

Since the power source on the boat may be limited,
it makes sense to break down the power demands of the respective Raspberry Pi modules .
Raspberry Pi requires a power supply with +5,1V. 
The amperage depends on the connected modules [^5]:

- Raspberry Pi Model B requires 500 mA minimum
- HDMI port 50mA
- Keyboard and mouse (varies between 100mA or over 1000mA)
- GPS module ~60mA

Keyboard and mouse have the largest variance, it makes sense to chose a keyboard with minimal power demand.
The mouse can even be omitted, in case the chosen display has touch support.

The power supply can be bridged with a power bank that is capable of
simultaneous charging and providing power. A sufficiently large power bank can
supply the boat navigation system trip.

### Optimize Performance

To optimize the performance of the Raspberry Pi, Martin Loschwitz suggests to set:

```
framebuffer_depth=32
framebuffer_ignore_alpha=1
```

in the `/boot/config.txt` file [^1]. Changes will take effect after a reboot.



[^1]: Martin Loschwitz: Maritime navigation with a Rasp Pi and OpenCPN, 2016, URL: http://www.raspberry-pi-geek.com/Archive/2016/16/Maritime-navigation-with-a-Rasp-Pi-and-OpenCPN.
[^3]: http://o-charts.org
[^2]: https://opencpn.org/OpenCPN/info/about.html
[^4]: https://opencpn.org/wiki/dokuwiki/doku.php?id=opencpn:opencpn_user_manual:getting_started:opencpn_installation:raspberrypi_rpi2
[^5]: https://www.raspberrypi.org/documentation/hardware/raspberrypi/power/README.md
