#!/system/bin/sh
MODDIR=${0%/*}

if ! grep -q TsingKernel /proc/version; then
   rm -rf $MODDIR
fi

