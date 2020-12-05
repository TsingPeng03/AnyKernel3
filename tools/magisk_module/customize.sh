# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this
REPLACE="
"

# This file (customize.sh) will be sourced by the main flash script after util_functions.sh
# If you need custom logic, please add them here as functions, and call these functions in
# update-binary. Refrain from adding code directly into update-binary, as it will make it
# difficult for you to migrate your modules to newer template versions.
# Make update-binary as clean as possible, try to only do function calls in it.
on_install() {
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
}
