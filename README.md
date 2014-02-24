DTN on Wi-Fi SD card
=========================================

This repository contains scripts and configuration files to turn a Wi-Fi SD card into a DTN node. This is the list of tested cards.

 * Transcend Wi-Fi SDHC card 16 GB (TS16GWSDHC10)

# Update binaries

The script "update-binaries.sh" is used to update the IBR-DTN binaries directly from the jenkins build server. Do that every time you want to update your binaries like dtnd, dtnping, dtnrecv and dtnsend.

```
$ ./update-binaries.sh
```

# Installation

First you need to add a second partition to your sd card. Plug it into your card reader and call your favorite partition manager and create two primary vfat partition on the SD card. In the original layout of the card, the first partition starts at 8192. To be safe, we should do the same in the new layout.

As example we split the 16 GB version the Transcend Wi-Fi SD card into 12 GB and 4 GB. This is the layout shown in fdisk.


```
$ sudo fdisk /dev/mmcblk0
Befehl (m für Hilfe): p

Disk /dev/mmcblk0: 16.1 GB, 16130244608 bytes
4 Köpfe, 16 Sektoren/Spur, 492256 Zylinder, zusammen 31504384 Sektoren
Einheiten = Sektoren von 1 × 512 = 512 Bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Festplattenidentifikation: 0x00000000

        Gerät  boot.     Anfang        Ende     Blöcke   Id  System
/dev/mmcblk0p1            8192    25174015    12582912    c  W95 FAT32 (LBA)
/dev/mmcblk0p2        25174016    31504383     3165184    c  W95 FAT32 (LBA)
```

As next, the partition must formatting with a vfat file-system.

```
$ sudo mkfs.vfat /dev/mmcblk0p1
$ sudo mkfs.vfat /dev/mmcblk0p2
```

Then mount both file-systems and copy the files in the directory /sd into the first and the files in /sd-ext into the second one.

```
$ mkdir mnt-sd
$ mount /dev/mmcblk0p1 mnt-sd
$ cp -rv sd/* mnt-sd/
$ umount mnt-sd
```
```
$ mkdir mnt-sd-ext
$ mount /dev/mmcblk0p2 mnt-sd-ext
$ cp -rv sd-ext/* mnt-sd-ext/
$ umount mnt-sd-ext
```

Installation is done now. Reboot the sd-card by ejecting and inserting it again into the card reader. The system should boot-up and open a Ad-Hoc Wi-Fi.

# Configuration

If you want to use dtnoutbox, e.g. for transferring images from your camera to another dtn-node, see the file:

```
sd-ext/dtnoutbox.conf
```

Simply uncomment the first line to enable dtnoutbox and adapt the other parameters as desired. If necessary adjust the optional parameters, too. For a short help, have a look at the dtnoutbox tool.

