#include "touchaa.h"
#include "UIKit/UIKit.h"
#include <sys/syscall.h>
#include "IOHIDEvent.h"
#include "IOHIDEventData.h"
#include "IOHIDEventTypes.h"
#include "IOHIDEventSystemClient.h"
#include "IOHIDEventSystem.h"
#include "IOHIDService.h"
#include "IOKitLib.h"

#import <AudioToolbox/AudioToolbox.h>
#import <CoreHaptics/CoreHaptics.h>
#import <dlfcn.h>
#import <os/log.h>
#import <objc/runtime.h>
#include <mach/mach_time.h>
#define TOUCH_UP 0
#define TOUCH_DOWN 1
#define TOUCH_MOVE 2

#define TOUCH_SENDER_ID_PLIST_FILE_NAME @"senderid.plist"
#define DOCUMENT_ROOT_FOLDER_NAME "ATop"
#define MAX_FINGER_INDEX 20

#define NOT_VALID 0
#define VALID 1
#define VALID_AT_NEXT_APPEND 2

#define EVENT_VALID_INDEX 0
#define EVENT_TYPE_INDEX 1
#define EVENT_X_INDEX 2
#define EVENT_Y_INDEX 3

// device screen size
static CGFloat device_screen_width = 0;
static CGFloat device_screen_height = 0;

IOHIDEventSystemClientRef ioHIDEventSystemForSenderID = NULL;

// touch event sender id
unsigned long long int senderID = 0x0;


static const uint32_t kInjectedIndexBase    = 10;     // 避开真人常用段
static const uint32_t kInjectedIdentityBase = 0xA000; // 高位身份段

static inline uint32_t mapInjectedIndex(int slot)    { return kInjectedIndexBase    + (uint32_t)slot; }
static inline uint32_t mapInjectedIdentity(int slot) { return kInjectedIdentityBase + (uint32_t)slot; }

// valid type x y
static float eventsToAppend[MAX_FINGER_INDEX][4]; // 0:valid 1:type 2:x 3:y

/*
get count from data array by socket
*/
static int getTouchCountFromDataArray(UInt8* dataArray)
{
    int count = (dataArray[0] - '0');
    return count;
}

/*
get type from data array by socket
*/
static int getTouchTypeFromDataArray(UInt8* dataArray, int index)
{
    int type = (dataArray[1+index*TOUCH_DATA_LEN] - '0');
    return type;
}

/*
get index from data array by socket
*/
static int getTouchIndexFromDataArray(UInt8* dataArray, int index)
{
    int touchIndex = 0;
    for (int i = 2; i <= 3; i++)
    {
        touchIndex += (dataArray[i+index*TOUCH_DATA_LEN] - '0')*pow(10, 3-i);
    }
    return touchIndex;
}

/*
get x from data array by socket
*/
static float getTouchXFromDataArray(UInt8* dataArray, int index)
{
    float x = 0;
    for (int i = 4; i <= 8; i++)
    {
        UInt8 c = dataArray[i + index * TOUCH_DATA_LEN];
        if (c < '0' || c > '9') continue; // 跳过非数字字符
        x += (c - '0') * powf(10, 8 - i);
    }
    return x / 10.0f; // 保留一位小数
}

static float getTouchYFromDataArray(UInt8* dataArray, int index)
{
    float y = 0;
    for (int i = 9; i <= 13; i++)
    {
        UInt8 c = dataArray[i + index * TOUCH_DATA_LEN];
        if (c < '0' || c > '9') continue;
        y += (c - '0') * powf(10, 13 - i);
    }
    return y / 10.0f;
}

/*
Get the child event of touching down.
index: index of the finger
x: coordinate x of the screen (before conversion)
y: coordinate y of the screen (before conversion)
*/
static IOHIDEventRef generateChildEventTouchDown(int slot, float x, float y)
{
   
    uint32_t index    = mapInjectedIndex(slot);
       uint32_t identity = mapInjectedIdentity(slot);
    IOHIDEventRef child = IOHIDEventCreateDigitizerFingerEvent(
        kCFAllocatorDefault,
        mach_absolute_time(),
        index,
        identity,
        kIOHIDDigitizerEventTouch | kIOHIDDigitizerEventStart,
        x, y,                      // 原始像素坐标
        0.0f, 0.0f, 0.0f,          // azimuth, altitude, twist
        1, 1, 0);                  // display, range, touchmask

    IOHIDEventSetFloatValue(child, 0xb0014, 0.04f); // major radius
    IOHIDEventSetFloatValue(child, 0xb0015, 0.04f); // minor radius
    return child;
}
/*
Get the child event of touching move.
index: index of the finger
x: coordinate x of the screen (before conversion)
y: coordinate y of the screen (before conversion)
*/
static IOHIDEventRef generateChildEventTouchMove(int slot, float x, float y)
{
    uint32_t index    = mapInjectedIndex(slot);
    uint32_t identity = mapInjectedIdentity(slot);
    IOHIDEventRef child = IOHIDEventCreateDigitizerFingerEvent(
        kCFAllocatorDefault,
        mach_absolute_time(),
        index,
        identity,
        kIOHIDDigitizerEventTouch | kIOHIDDigitizerEventPosition,
        x, y,
        0.0f, 0.0f, 0.0f,
        1, 1, 0);

    IOHIDEventSetFloatValue(child, 0xb0014, 0.04f);
    IOHIDEventSetFloatValue(child, 0xb0015, 0.04f);
    return child;
}

/*
Get the child event of touching up.
index: index of the finger
x: coordinate x of the screen (before conversion)
y: coordinate y of the screen (before conversion)
*/
static IOHIDEventRef generateChildEventTouchUp(int slot, float x, float y)
{
    uint32_t index    = mapInjectedIndex(slot);
    uint32_t identity = mapInjectedIdentity(slot);
    IOHIDEventRef child = IOHIDEventCreateDigitizerFingerEvent(
        kCFAllocatorDefault,
        mach_absolute_time(),
        index,
         identity,
        kIOHIDDigitizerEventTouch | kIOHIDDigitizerEventStop,
        x, y,
        0.0f, 0.0f, 0.0f,
        0, 0, 0);  // pressure = 0 表示抬起

    IOHIDEventSetFloatValue(child, 0xb0014, 0.04f);
    IOHIDEventSetFloatValue(child, 0xb0015, 0.04f);
    return child;
}
/**
Append child event to parent
*/
static void appendChildEvent(IOHIDEventRef parent,
                             int type,
                             int index,
                             float x,
                             float y)
{
    switch (type) {
        case TOUCH_MOVE:
            IOHIDEventAppendEvent(parent,
                generateChildEventTouchMove(index, x, y));
            break;

        case TOUCH_DOWN:
            IOHIDEventAppendEvent(parent,
                generateChildEventTouchDown(index, x, y));
            break;

        case TOUCH_UP:
            IOHIDEventAppendEvent(parent,
                generateChildEventTouchUp(index, x, y));
            break;

        default:
        
            break;
    }
}
/**
Perform touch events with data received from socket
*/
void performTouchFromRawData(NSMutableArray* touchList)
{
    IOHIDEventRef parent =
        IOHIDEventCreateDigitizerEvent(kCFAllocatorDefault, mach_absolute_time(),
                                       3, 99, 1, 0, 0,
                                       0.f, 0.f, 0.f, 0.f, 0.f, 0, 0, 0);

    IOHIDEventSetIntegerValue(parent, 0xb0019, 1);
    IOHIDEventSetIntegerValue(parent, 0x4,      1);
    
#define kIOHIDEventDigitizerSenderID 0x000000010000027F
IOHIDEventSetSenderID(parent, kIOHIDEventDigitizerSenderID);

    for (int i = 0; i < touchList.count; i++)
    {
        NSDictionary* dic = [touchList objectAtIndex:i];
        NSNumber* n_touchType = [dic objectForKey:@"touchType"];
        NSNumber* n_x = [dic objectForKey:@"x"];
        NSNumber* n_y = [dic objectForKey:@"y"];
        NSNumber* n_index = [dic objectForKey:@"index"];
        
        int touchType = [n_touchType intValue];
        float x = [n_x floatValue];
        float y = [n_y floatValue];
        int index = [n_index intValue];
        appendChildEvent(parent, touchType, index, x, y);

        switch (touchType) {
            case TOUCH_MOVE:
                eventsToAppend[index][EVENT_VALID_INDEX] = VALID_AT_NEXT_APPEND;
                eventsToAppend[index][EVENT_TYPE_INDEX]  = TOUCH_MOVE;
                eventsToAppend[index][EVENT_X_INDEX]     = x;
                eventsToAppend[index][EVENT_Y_INDEX]     = y;
                break;
            case TOUCH_DOWN:
                eventsToAppend[index][EVENT_VALID_INDEX] = VALID_AT_NEXT_APPEND;
                eventsToAppend[index][EVENT_TYPE_INDEX]  = TOUCH_DOWN;
                eventsToAppend[index][EVENT_X_INDEX]     = x;
                eventsToAppend[index][EVENT_Y_INDEX]     = y;
                break;
            case TOUCH_UP:
                eventsToAppend[index][EVENT_VALID_INDEX] = NOT_VALID;
                break;
        }
    }

    /* 第二轮：把缓存里 pending 的事件补发一次（保持原作者逻辑） */
    for (int i = 0; i < MAX_FINGER_INDEX; i++) {
        if (eventsToAppend[i][EVENT_VALID_INDEX] == VALID) {
            appendChildEvent(parent,
                             (int)eventsToAppend[i][EVENT_TYPE_INDEX],
                             i,
                             eventsToAppend[i][EVENT_X_INDEX],
                             eventsToAppend[i][EVENT_Y_INDEX]);
        } else if (eventsToAppend[i][EVENT_VALID_INDEX] == VALID_AT_NEXT_APPEND) {
            eventsToAppend[i][EVENT_VALID_INDEX] = VALID;
        }
    }

    /* 其他父事件字段保持不变 */
    IOHIDEventSetIntegerValue(parent, 0xb0007, 0x23);
    IOHIDEventSetIntegerValue(parent, 0xb0008, 0x1);
    IOHIDEventSetIntegerValue(parent, 0xb0009, 0x1);

    postIOHIDEvent(parent);
    CFRelease(parent);
}

/**
Post the parent event
*/
static void postIOHIDEvent(IOHIDEventRef event)
{
    static IOHIDEventSystemClientRef ioSystemClient = NULL;
    if (!ioSystemClient){
        ioSystemClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    }
 
        IOHIDEventSetSenderID(event, senderID);
  
    IOHIDEventSystemClientDispatchEvent(ioSystemClient, event);
}




NSString* getDocumentRoot()
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"/var/mobile/Library/%s/" ,DOCUMENT_ROOT_FOLDER_NAME];
}

/*
Get sender id. If the device has not been rebooted, read senderid from file. Otherwise start set sender id callback
*/
static inline uint64_t LoadSIDFromICloud(void) {
    NSUbiquitousKeyValueStore *store = NSUbiquitousKeyValueStore.defaultStore;
    return (uint64_t)[store longLongForKey:@"TouchSenderID"];
}
void initSenderId()
{

            
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // I know the code here is bad here, change this later.
        while (true)
        {
            [NSThread sleepForTimeInterval:2.0f];
            senderID = LoadSIDFromICloud();
          
        }
    });

}
void touchBegin(int index ,float x, float y) {
   
 
    NSMutableArray* touchList = [[NSMutableArray alloc] init];
    NSMutableDictionary *touch = [NSMutableDictionary dictionary];
    [touch setObject:[NSNumber numberWithInt:TOUCH_DOWN] forKey:@"touchType"];
    [touch setObject:[NSNumber numberWithFloat:x] forKey:@"x"];
    [touch setObject:[NSNumber numberWithFloat:y] forKey:@"y"];
    [touch setObject:[NSNumber numberWithInt:index] forKey:@"index"];
    [touchList addObject:touch];
    performTouchFromRawData(touchList);
    

}

void touchMove(int index, float x, float y) {
  
    NSMutableArray *touchList = [[NSMutableArray alloc] init];
    NSMutableDictionary *touch = [NSMutableDictionary dictionary];
    [touch setObject:[NSNumber numberWithInt:TOUCH_MOVE] forKey:@"touchType"];
    [touch setObject:[NSNumber numberWithFloat:x] forKey:@"x"];
    [touch setObject:[NSNumber numberWithFloat:y] forKey:@"y"];
    [touch setObject:[NSNumber numberWithInt:index] forKey:@"index"];
    [touchList addObject:touch];
    performTouchFromRawData(touchList);
}

void touchEnd(int index, float x, float y) {
    
    NSMutableArray *touchList = [[NSMutableArray alloc] init];
    NSMutableDictionary *touch = [NSMutableDictionary dictionary];
    [touch setObject:[NSNumber numberWithInt:TOUCH_UP] forKey:@"touchType"];
    [touch setObject:[NSNumber numberWithFloat:x] forKey:@"x"];
    [touch setObject:[NSNumber numberWithFloat:y] forKey:@"y"];
    [touch setObject:[NSNumber numberWithInt:index] forKey:@"index"];
    [touchList addObject:touch];
    performTouchFromRawData(touchList);
}

