# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=ExampleKernel by osm0sis @ xda-developers
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=maguro
device.name2=toro
device.name3=toroplus
device.name4=tuna
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## NetHunter additions
mount -o rw,remount -t auto /system;
mount -o rw,remount -t auto /dev/block/bootdevice/by-name/system$slot /system_root;
SYSTEM="/system";
SYSTEM_ROOT="/system_root";

insert_line $SYSTEM_ROOT/ueventd.rc "/dev/hidg" after "/dev/vndbinder.*root.*root" "# HID driver\n/dev/hidg* 0666 root root";

if [ ! "$(grep Kali $SYSTEM_ROOT/init.usb.configfs.rc)" ]; then
  ui_print " " "Patching usb.configfs" " ";
  cat $home/tools/init.nethunter.rc >> $SYSTEM_ROOT/init.usb.configfs.rc 
fi;

mount -o ro,remount -t auto /system;
## End NetHunter additions

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## AnyKernel install
dump_boot;

write_boot;
## end install

