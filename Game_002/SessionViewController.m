//
//  SessionViewController.m
//  Game_002
//
//  Created by 寺内 信夫 on 2014/09/27.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import "SessionViewController.h"

@interface SessionViewController ()

@end

@implementation SessionViewController

//@synthesize myPeerID;
//@synthesize serviceType;
//@synthesize nearbyServiceAdvertiser;
//@synthesize nearbyServiceBrowser;
//@synthesize session;

//@synthesize labelMyPeerIDIPHONE;
//@synthesize labelYourPeerIDIPHONE;
//@synthesize labelMyPeerIDIPAD;
//@synthesize labelYourPeerIDIPAD;

//- (BOOL)isPhone
//{
//
//	return ( UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPhone );
//
//}

- (void)viewDidLoad
{
	
	[super viewDidLoad];

	
	array_PeerID  = [[NSMutableArray alloc] init];
	
	
	NSUUID *uuid = [NSUUID UUID];
	
	self.myPeerID = [[MCPeerID alloc] initWithDisplayName: [uuid UUIDString]];
	
	self.session = [[MCSession alloc] initWithPeer: self.myPeerID
								  securityIdentity: nil
							  encryptionPreference: MCEncryptionNone];
	
	self.session.delegate = self;

	NSString *namePeerID = self.myPeerID.displayName;
	
	NSLog(@"[peerID.displayName] %@", namePeerID);
	
//	if ( [self isPhone] ) {
//		
//		labelMyPeerIDIPHONE.text = myPeerID.displayName;
//	
//	} else {
//
//		labelMyPeerIDIPAD.text = myPeerID.displayName;
//	
//	}
	
	self.serviceType = @"p2ptest";
	

	UIDevice *dev = [UIDevice currentDevice];

	//NSLog( @"%@", dev.localizedModel );
	
	self.label_Model.text = dev.localizedModel;
	
	[self.switch_Server setOn: YES];

	[self switch_Server_Action: nil];
	
}

- (void)didReceiveMemoryWarning
{

	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.

}

- (IBAction)switch_Server_Action:(id)sender
{

	if ( self.switch_Server.on ) {
		
		self.label_Server.text = @"サーバーにする";

		self.nearbyServiceAdvertiser.delegate = nil;
		self.nearbyServiceAdvertiser = nil;
		
		self.nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer: self.myPeerID
																	 serviceType: self.serviceType];
		
		self.nearbyServiceBrowser.delegate = self;
		
		[self.nearbyServiceBrowser startBrowsingForPeers];
	
	} else {
		
		self.label_Server.text = @"サーバーにしない";

		self.nearbyServiceBrowser.delegate = nil;
		self.nearbyServiceBrowser = nil;
		
		self.nearbyServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer: self.myPeerID
																		 discoveryInfo: nil
																		   serviceType: self.serviceType];
		
		self.nearbyServiceAdvertiser.delegate = self;
		
		[self.nearbyServiceAdvertiser startAdvertisingPeer];
	
	}
	
}

- (void)showAlert: (NSString *)title
		  message: (NSString *)message
{

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
													message: message
												   delegate: self
										  cancelButtonTitle: @"OK"
										  otherButtonTitles: nil];
	
	[alert show];

}


# pragma mark - MCNearbyServiceBrowserDelegate

// --------------------
// MCNearbyServiceBrowserDelegate
// --------------------

// Error Handling Delegate Methods

// browser:didNotStartBrowsingForPeers:
// Called when a browser failed to start browsing for peers. (required)
- (void)browser: (MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{

	if(error){
		NSLog(@"[error localizedDescription] %@", [error localizedDescription]);
	}
	
}

// Peer Discovery Delegate Methods

// browser:foundPeer:withDiscoveryInfo:
// Called when a new peer appears. (required)
- (void)  browser: (MCNearbyServiceBrowser *)browser
	    foundPeer: (MCPeerID *)peerID
withDiscoveryInfo: (NSDictionary *)info
{

	NSLog( @"%@", peerID.displayName );
	
//	NSLog(@"found Peer : %@", peerID.displayName);
//	
//	NSDictionary *dir = [NSDictionary dictionaryWithObjectsAndKeys:
//						 @"peer_id", peerID,
//						 @"info"   , info  , nil];
//	
//	[array_PeerID addObject: dir];
	
	
	[self showAlert: @"found Peer" message:peerID.displayName];
	
//	if([self isPhone]){
//		labelYourPeerIDIPHONE.text = peerID.displayName;
//	}else{
//		labelYourPeerIDIPAD.text = peerID.displayName;
//	}
	
	[self.nearbyServiceBrowser invitePeer: peerID
								toSession: self.session withContext:[@"Welcome" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
}

// browser:lostPeer:
// Called when a peer disappears. (required)
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{

}


# pragma mark - MCNearbyServiceAdvertiserDelegate

// --------------------
// MCNearbyServiceAdvertiserDelegate
// --------------------

// Error Handling Delegate Methods

// advertiser:didNotStartAdvertisingPeer:
// Called when advertisement fails. (required)
- (void)        advertiser: (MCNearbyServiceAdvertiser *)advertiser
didNotStartAdvertisingPeer: (NSError *)error
{

	if(error){
		NSLog(@"%@", [error localizedDescription]);
		[self showAlert:@"ERROR didNotStartAdvertisingPeer" message:[error localizedDescription]];
	}
	
}

// Invitation Handling Delegate Methods

// advertiser:didReceiveInvitationFromPeer:withContext:invitationHandler:
// Called when a remote peer invites the app to join a session. (required)
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{

	invitationHandler(TRUE, self.session);
	[self showAlert:@"didReceiveInvitationFromPeer" message:@"accept invitation!"];
	
	if ( context ) {
		
		NSLog( @"%@", context );
		
	}
	
}


#pragma mark - MCSessionDelegate

// --------------------
// MCSessionDelegate
// --------------------

// MCSession Delegate Methods

// session:didReceiveData:fromPeer:
// Called when a remote peer sends an NSData object to the local peer. (required)
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{

	NSString *receivedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[self showAlert:@"didReceiveData" message:receivedData];
}

// session:didStartReceivingResourceWithName:fromPeer:withProgress:
// Called when a remote peer begins sending a file-like resource to the local peer. (required)
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{

}

// session:didFinishReceivingResourceWithName:fromPeer:atURL:withError:
// Called when a remote peer sends a file-like resource to the local peer. (required)
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{

}

// session:didReceiveStream:withName:fromPeer:
// Called when a remote peer opens a byte stream connection to the local peer. (required)
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{

}

// session:peer:didChangeState:
// Called when the state of a remote peer changes. (required)
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{

	NSLog(@"[peerID] %@", peerID);
	NSLog(@"[state] %d", state);
	//[self showAlert:@"didChangeState" message:[NSString stringWithFormat:@"[state] %d", state]];
	
	if(state == MCSessionStateConnected && self.session){
		NSLog(@"session sends data!");
		NSError *error;
		NSString *message = [NSString stringWithFormat:@"message from %@", self.myPeerID.displayName];
		[self.session sendData:[message dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataReliable error:&error];
		//[self showAlert:@"Send data" message:@"hello"];
	}
}

// session:didReceiveCertificate:fromPeer:certificateHandler:
// Called to authenticate a remote peer when the connection is first established. (required)
- (BOOL)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{

	certificateHandler(TRUE);
	return TRUE;
}


# pragma mark - Advertising

// -----------------------------
// Advertising
// -----------------------------

- (void)startAdvertising
{
	
	NSDictionary *discoveryInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
								   @"foo", @"bar", @"bar", @"foo", nil];
	
	self.nearbyServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer: self.myPeerID
																	 discoveryInfo: discoveryInfo
																	   serviceType: self.serviceType];
	self.nearbyServiceAdvertiser.delegate = self;
	
	[self.nearbyServiceAdvertiser startAdvertisingPeer];

}

- (IBAction)btnStartAdvertisingIPHONE:(id)sender
{

	//[self showAlert:@"iPhone" message:@"startAdvertisingPeer"];
	[self startAdvertising];

}

- (IBAction)btnStartAdvertisingIPAD:(id)sender
{

	//[self showAlert:@"iPad" message:@"startAdvertisingPeer"];
	[self startAdvertising];

}

- (IBAction)btnStopAdvertisingIPHONE:(id)sender
{

	//[self showAlert:@"iPhone" message:@"stopAdvertisingPeer"];
	[self.nearbyServiceAdvertiser stopAdvertisingPeer];

}

- (IBAction)btnStopAdvertisingIPAD:(id)sender
{

	//[self showAlert:@"iPad" message:@"stopAdvertisingPeer"];
	[self.nearbyServiceAdvertiser stopAdvertisingPeer];

}


# pragma mark - Browsing

// -----------------------------
// Browsing
// -----------------------------

- (IBAction)btnStartBrowsingIPHONE:(id)sender
{

	//[self showAlert:@"iPhone" message:@"startBrowsingForPeers"];
	[self.nearbyServiceBrowser startBrowsingForPeers];
	
}

- (IBAction)btnStopBrowsingIPHONE:(id)sender
{

	//[self showAlert:@"iPhone" message:@"stopBrowsingForPeers"];
	[self.nearbyServiceBrowser stopBrowsingForPeers];
	
}

- (IBAction)btnStartBrowsingIPAD:(id)sender
{

	//[self showAlert:@"iPad" message:@"startBrowsingForPeers"];
	[self.nearbyServiceBrowser startBrowsingForPeers];
	
}

- (IBAction)btnStopBrowsingIPAD:(id)sender
{

	//[self showAlert:@"iPad" message:@"stopBrowsingForPeers"];
	[self.nearbyServiceBrowser stopBrowsingForPeers];
	
}

@end