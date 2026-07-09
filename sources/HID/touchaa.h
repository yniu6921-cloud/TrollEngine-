#ifndef TOUCH_H
#define TOUCH_H
#include "IOHIDEvent.h"
#include "IOHIDEventData.h"
#include "IOHIDEventTypes.h"
#include "IOHIDEventSystemClient.h"
#include "IOHIDEventSystem.h"
#include "IOHIDService.h"
#include "IOKitLib.h"

#import <dlfcn.h>
#import <os/log.h>
#import <objc/runtime.h>
#include <mach/mach_time.h>
#if __cplusplus
extern "C" {
#endif

extern NSArray *globalTouchList;
const int TOUCH_DATA_LEN = 13;
NSArray *getGlobalTouchList();
static int getTouchCountFromDataArray(UInt8* dataArray);
static int getTouchTypeFromDataArray(UInt8* dataArray, int index);
static int getTouchIndexFromDataArray(UInt8* dataArray, int index);
static float getTouchXFromDataArray(UInt8* dataArray, int index);
static float getTouchYFromDataArray(UInt8* dataArray, int index);
void performTouchFromRawData(UInt8 *eventData);

static IOHIDEventRef generateChildEventTouchDown(int index, float x, float y);
static IOHIDEventRef generateChildEventTouchMove(int index, float x, float y);
static IOHIDEventRef generateChildEventTouchUp(int index, float x, float y);

static void postIOHIDEvent(IOHIDEventRef event);
static void setSenderIdCallback(void* target, void* refcon, IOHIDServiceRef service, IOHIDEventRef event);
NSArray *getSenderIDs();


//exter
void initTouchGetScreenSize(float width,float height);
void huoqu(uint64_t aaa);


/*触摸按下 传入标准化0-1坐标*/
void touchBegin(int index ,float x, float y);
/*触摸移动 传入标准化0-1坐标*/
void touchMove(int index,float x,float y);
/*触摸抬起 传入标准化0-1坐标*/
void touchEnd(int index,float x,float y);
/*触摸初始化必须调用*/
void initSenderId();
#ifdef __cplusplus
}
#endif

#endif

