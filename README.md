**Note 2**: As of 2017-08-23, I no longer seem to need to use the detailed fixes. Running a fresh Solus 3 install (Linux 4.12.8), all of my hotkeys work out of the box, as does wifi. GPU is still not working outside of Ubuntu, but it was never really stable there either. Will continue to investigate when able.

***

**Note**: As of 2017-04-05, I am not using Ubuntu anymore (I changed months ago, actually). Though the mentioned script should still hold true, the following is probably more useful, and has changed a bit:

Use the boot options
```
acpi_osi=!
```
and
```
acpi_backlight=native
```
to make shortcut keys work and allow a wide range of backlight level.

To make wifi work, run:
```
echo "options asus_nb_wmi wapf=4" | sudo tee /etc/modprobe.d/asus_nb_wmi.conf
```

***

A simple script to automatically configure your system to fix any compatability issues I found. Use at your own risk. Tested on Ubuntu 16.04
