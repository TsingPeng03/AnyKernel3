# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=TsingKernel by @TsingPeng
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=dipper
device.name2=equuleus
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
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

# Set Android version for kernel
ver="$(file_getprop /system/build.prop ro.build.version.release)"
if [ ! -z "$ver" ]; then
  patch_cmdline "androidboot.version" "androidboot.version=$ver"
else
  patch_cmdline "androidboot.version" ""
fi

## AnyKernel install
dump_boot;
rm -rf /data/adb/modules/TsingKernel;
cp -rf $home/tools/magisk_module /data/adb/modules/TsingKernel;
write_boot;
## end install

