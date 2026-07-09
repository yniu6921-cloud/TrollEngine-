#import <Foundation/Foundation.h>

@class GCDAsyncSocket;
@class WebSocket;

#if TARGET_OS_IPHONE
  #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000 // iPhone 4.0
    #define IMPLEMENTED_PROTOCOLS <NSNetServiceDelegate>
  #else
    #define IMPLEMENTED_PROTOCOLS 
  #endif
#else
  #if MAC_OS_X_VERSION_MIN_REQUIRED >= 1060 // Mac OS X 10.6
    #define IMPLEMENTED_PROTOCOLS <NSNetServiceDelegate>
  #else
    #define IMPLEMENTED_PROTOCOLS 
  #endif
#endif


@interface HTTPServer : NSObject IMPLEMENTED_PROTOCOLS
{
	GCDAsyncSocket *asyncSocket;
	dispatch_queue_t serverQueue;
	dispatch_queue_t connectionQueue;
	void *IsOnServerQueueKey;
	void *IsOnConnectionQueueKey;
	NSString *documentRoot;
	Class connectionClass;
	NSString *interface;
	UInt16 port;
	NSNetService *netService;
	NSString *domain;
	NSString *type;
	NSString *name;
	NSString *publishedName;
	NSDictionary *txtRecordDictionary;
	NSMutableArray *connections;
	NSMutableArray *webSockets;
	NSLock *connectionsLock;
	NSLock *webSocketsLock;
	BOOL isRunning;
}
- (NSString *)documentRoot;
- (void)setDocumentRoot:(NSString *)value;
- (Class)connectionClass;
- (void)setConnectionClass:(Class)value;
- (NSString *)interface;
- (void)setInterface:(NSString *)value;
- (UInt16)port;
- (UInt16)listeningPort;
- (void)setPort:(UInt16)value;
- (NSString *)domain;
- (void)setDomain:(NSString *)value;
- (NSString *)name;
- (NSString *)publishedName;
- (void)setName:(NSString *)value;
- (NSString *)type;
- (void)setType:(NSString *)value;
- (void)republishBonjour;
- (NSDictionary *)TXTRecordDictionary;
- (void)setTXTRecordDictionary:(NSDictionary *)dict;
- (BOOL)start:(NSError **)errPtr;
- (void)stop;
- (void)stop:(BOOL)keepExistingConnections;
- (BOOL)isRunning;
- (void)addWebSocket:(WebSocket *)ws;
- (NSUInteger)numberOfHTTPConnections;
- (NSUInteger)numberOfWebSocketConnections;
@end
