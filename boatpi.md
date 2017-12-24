---
author: Lukas Galke
date: 2017/12/24
title: BoatPi
subtitle: A Boat Navigation System Using a Raspberry Pi
documentclass: scrartcl
links-as-notes: True
colorlinks: True
toc: True
---


# Boat Navigation System

The present document comprises a guide for building a navigation system for a
boat using a Raspberry Pi. We focus on creating a chart plotter using a GPS
module. We make use of the [OpenCPN](https://opencpn.org) software, to display
the location on a map.

The guide by @christoffersen16 describes a setup using an on-board GPS module.
The author gives interesting insights on the electronic properties of the
setup. Considering software, the guide relies on the [openplotter
platform](http://www.sailoog.com/openplotter). The platform offers multiple
features besides the chart plotter itself, such as weather forecasting, a
compass, or several interfaces for an automated boat control system. The
openplotter platform can also be deployed on a Raspberry Pi. Still, the extra
features require hardware modules. For the present guide, we focus on the chart
plotting software OpenCPN which only requires a GPS module.

In the following, we [first](#prep) describe the basic setup of the Raspberry Pi as well as the GPS and the chart plotter software. [Then](#boat), we depict some
optimization methods for the Raspberry and highlight some boat-specific
adaptions which need to be considered independently of this guide.

## Preparation {#prep}

### Requirements

- Raspberry Pi
- Power Supply
- An SD card with Raspbian (jessie or higher) installed
- GPS Module
- Mouse and Keyboard
- Display (preferably without additional power demands)

We start by setting up the Raspberry Pi. Insert the SD card, attach mouse and keyboard. Follow the manufacturer's instruction to set up the display.
Connect the GPS module with the RPi and finally, connect the power supply.
After the Raspberry has booted, assert that its software is up-to-date (`apt-get update && apt-get upgrade`).

### Installing GPS Requirements

Next, we install the software to communicate with the GPS module, namely `gpsd`.
To install the `gpsd` GPS daemon, issue the following command:

```sh
sudo apt-get install gpsd gpsd-clients python-gps
```

After the `gpsd` package is installed, we need to supply the interface
identifier, on which the service should listen. To modify the service's
configuration, edit the `/etc/default/gpsd` file. Insert the path for the
interface (e.g. `/dev/ttyACM0`) of the GPS module into the `DEVICES` line. The
correct interface can be identified by inspecting the output of `ls /dev/`. In
the same file, add `-b` to `GPSD_OPTIONS`. Restart the `gpsd` service via
`service gpsd restart`. Assert that the GPS service is working properly by
issuing `cgps` in a command prompt. In case something went wrong, consult the
[detailed installation instructions of
`gpsd`](http://www.catb.org/gpsd/installation.html).

### Setting up OpenCPN

Now, we install the [OpenCPN](https://opencpn.org) navigation software on the Raspberry Pi:

First, edit the package sources via `sudo nano /etc/apt/sources.list` and append the following line:

```sh
deb http://ppa.launchpad.net/opencpn/opencpn/ubuntu/ trusty main
```

Make sure to save the file after editing.
Then, retrieve the key from the keyserver via

```sh
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C865EB40
```

On a command prompt and update the package list via

```sh
sudo apt-get update
```

Finally, install the `opencpn` software itself by 

```sh
sudo apt-get install opencpn
```

*Optional*, if desired, install available OpenCPN plugins by append a `*`

```sh
sudo apt-get install opencpn*
```




## Getting on Board {#boat}

When deploying the navigation system on the actual boat.

### Reduce screen resolution

When the GPU of the Raspberry Pi is to weak or the power consumption is too high,
reduce the screen resolution:

1. Run `sudo raspi-config`, navigate to *Advanced Options > Resolution* and set resolution according to your display (720p is recommended).
1. Run `sudo reboot`, to let changes within `raspi-config` take effect.

### Optimize performance

To further optimize the performance of the Raspberry Pi, @losch16 suggests to set:

```
framebuffer_depth=32
framebuffer_ignore_alpha=1
```

in the `/boot/config.txt` file, before performing a reboot.
This reduced the buffer rate and transparency values for the display.

### Power Consumption

It might be necessary to make use of an *12 to 5 Volt converter* while
connecting the Raspberry Pi with the boats power source. Since the power source
on the boat may be limited, it makes sense to break down the power demands of
the respective Raspberry Pi modules. Raspberry Pi requires a power supply with
+5,1V. According to the official Raspberry Pi
[website](https://www.raspberrypi.org/documentation/hardware/raspberrypi/power/README.md),
the amperage depends on the connected modules:

- **Raspberry Pi Model B**: minimum 500 mA
- **HDMI port** 50mA
- **Keyboard and mouse:** varies between 100mA or over 1000mA
- **GPS module**: about 60mA

Keyboard and mouse have the largest variance. Thus, the power demand
specification of the keyboard and mouse are the main criterion for usage. In
case the selected display has touch functionality, the mouse can be omitted.
Combined keyboard and mouse modules with low power demand should be also
considered.

The power supply can be bridged with a power bank that is capable of
simultaneous charging and providing power. A sufficiently large power bank can
supply the boat navigation system trip.


### Supported Chart Formats

OpenCPN supports the following [chart formats](https://opencpn.org/OpenCPN/info/about.html):

- Worldwide standard S56 and encrypted S63 vector chart.
- BSB v3 and earlier raster charts.
- CM93 vector charts with per cell offset corrections
- ENCs, distributed by [o-charts](http://o-charts.org) for selected regions

When conversion from different formats is required, please refer to the [Supplementary Software Manual](https://opencpn.org/wiki/dokuwiki/doku.php?id=opencpn:supplementary_software) of OpenCPN.


## Summary

In summary, we have seen how to turn a Raspberry Pi into a chart plotter using
OpenCPN. For more details on using OpenCPN, please refer to the [OpenCPN User
Manual](https://opencpn.org/wiki/dokuwiki/doku.php?id=opencpn:opencpn_user_manual).
The follow-up steps could include further modules (weather, compass, ...). In
this case, the openplotter platform could prove helpful.

---

## References

