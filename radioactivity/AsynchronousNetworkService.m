
#import "AsynchronousNetworkService.h"


static AsynchronousNetworkService* sharedInstance = nil;

@implementation AsynchronousNetworkService


@synthesize password;
@synthesize username;
@synthesize response;
@synthesize data;
@synthesize delegate;
@synthesize urlString;
@synthesize urlconnection;
@synthesize isDownloading;

- (void) start{
	self.isDownloading = NO;
	NSURL *url = [NSURL URLWithString:self.urlString];
	if (!url)
	{
		NSString *reason = [NSString stringWithFormat:@"Could not create URL from string %@", self.urlString];
		DELEGATE_CALLBACK(dataDownloadFailed:, reason);
		return;
	}
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	if (!theRequest)
	{
		NSString *reason = [NSString stringWithFormat:@"Could not create URL request from string %@", self.urlString];
		DELEGATE_CALLBACK(dataDownloadFailed:, reason);
		return;
	}
	
	self.urlconnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (!self.urlconnection)
	{
		NSString *reason = [NSString stringWithFormat:@"URL connection failed for string %@", self.urlString];
		DELEGATE_CALLBACK(dataDownloadFailed:, reason);
		return;
	}
	
	self.isDownloading = YES;
	
	// Create the new data object
	self.data = [NSMutableData data];
	self.response = nil;
	
	[self.urlconnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) cleanup{
	self.data = nil;
	self.response = nil;
	self.urlconnection = nil;
	self.urlString = nil;
	self.isDownloading = NO;
}



//try positive
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    int httpStatusCode = 0;
    if ([NSHTTPURLResponse class] == [response class])
        httpStatusCode = [response statusCode]; 
    if(httpStatusCode >= 400){
        self.isDownloading = NO;
        NSLog(@"Error: HTTP-Status-Code: %i", httpStatusCode);
        DELEGATE_CALLBACK(dataDownloadFailed:, @"Failed HTTP-Connection");
        [self cleanup];
    }  
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData{
	// append the new data and update the delegate
	[self.data appendData:theData];
	if (self.response)
	{
		float expectedLength = [self.response expectedContentLength];
		float currentLength = self.data.length;
		float percent = currentLength / expectedLength;
		DELEGATE_CALLBACK(dataDownloadAtPercent:, NUMBER(percent));
	}
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	// finished downloading the data, cleaning up
	self.response = nil;
	
	// Delegate is responsible for releasing data
	if (self.delegate)
	{
		NSData *theData = [self.data retain];
		DELEGATE_CALLBACK(didReceiveData:, theData);
	}
	[self.urlconnection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[self cleanup];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	self.isDownloading = NO;
	NSLog(@"Error: Failed connection, %@", [error localizedDescription]);
	DELEGATE_CALLBACK(dataDownloadFailed:, @"Failed Connection");
	[self cleanup];
}




- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	if (!username || !password) 
	{
		[[challenge sender] useCredential:nil forAuthenticationChallenge:challenge];
		return;
	}
	NSURLCredential *cred = [[[NSURLCredential alloc] initWithUser:self.username password:self.password persistence:NSURLCredentialPersistenceNone] autorelease];
	[[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
}


+ (AsynchronousNetworkService*) sharedInstance{
	if(!sharedInstance) sharedInstance = [[self alloc] init];
    return sharedInstance;
}

+ (void) download:(NSString *) aURLString{
	if (sharedInstance.isDownloading)
	{
		NSLog(@"Error: Cannot start new download until current download finishes");
		DELEGATE_CALLBACK(dataDownloadFailed:, @"");
		return;
	}
	
	sharedInstance.urlString = aURLString;
	[sharedInstance start];
}



+ (void) cancel{
	if (sharedInstance.isDownloading) [sharedInstance.urlconnection cancel];
}


- (void) dealloc
{
	[response dealloc];
	[data dealloc];
	[urlString dealloc];
	[password dealloc];
	[username dealloc];
	[urlconnection dealloc];
	[super dealloc];
}

@end
