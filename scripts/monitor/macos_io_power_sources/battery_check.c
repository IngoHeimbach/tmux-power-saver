#ifdef __APPLE__

#include <CoreServices/CoreServices.h>
#include <IOKit/IOMessage.h>
#include <IOKit/ps/IOPowerSources.h>
#include <stdio.h>


#define UNUSED(param) ((void)(param))


static void power_callback(void *context) {
    CFDictionaryRef adapter_details;
    UNUSED(context);

    if ((adapter_details = IOPSCopyExternalPowerAdapterDetails()) != NULL) {
        printf("ac\n");
        CFRelease(adapter_details);
    } else {
        printf("battery\n");
    }
    fflush(stdout);
}

static void initialize_power_notifications(void) {
    CFRunLoopAddSource(CFRunLoopGetCurrent(), IOPSNotificationCreateRunLoopSource(power_callback, NULL),
                       kCFRunLoopDefaultMode);
}

int main(void) {
    power_callback(NULL); /* Run once to get a first notification */
    initialize_power_notifications();
    CFRunLoopRun();
    return 0;
}

#else
#error This program can only be used on macos.
#endif
