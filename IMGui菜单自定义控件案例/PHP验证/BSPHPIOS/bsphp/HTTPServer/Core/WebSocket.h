#import <Foundation/Foundation.h>

@class HTTPMessage;
@class GCDAsyncSocket;


#define WebSocketDidDieNotification  @"WebSocketDidDie"

@interface WebSocket : NSObject
{
	dispatch_queue_t websocketQueue;
	
	HTTPMessage *request;
	GCDAsyncSocket *asyncSocket;
	
	NSData *term;
	
	BOOL isStarted;
	BOOL isOpen;
	BOOL isVersion76;
	
	id __unsafe_unretained delegate;
}
+ (BOOL)isWebSocketRequest:(HTTPMessage *)request;
- (id)initWithRequest:(HTTPMessage *)request socket:(GCDAsyncSocket *)socket;
@property (/* atomic */ unsafe_unretained) id delegate;
@property (nonatomic, readonly) dispatch_queue_t websocketQueue;
- (void)start;
- (void)stop;
- (void)sendMessage:(NSString *)msg;
- (void)sendData:(NSData *)msg;
- (void)didOpen;
- (void)didReceiveMessage:(NSString *)msg;
- (void)didClose;

@end

#pragma mark -

@protocol WebSocketDelegate
@optional

- (void)webSocketDidOpen:(WebSocket *)ws;

- (void)webSocket:(WebSocket *)ws didReceiveMessage:(NSString *)msg;

- (void)webSocketDidClose:(WebSocket *)ws;

@end
