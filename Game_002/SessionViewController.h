//
//  SessionViewController.h
//  Game_002
//
//  Created by 寺内 信夫 on 2014/09/27.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface SessionViewController : UIViewController < MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate >
{

//	MCPeerID *myPeerID;
//	NSString *serviceType;

	NSMutableArray *array_PeerID;
	
}

@property (strong, nonatomic) MCPeerID *myPeerID;
@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) NSString *serviceType;
@property (strong, nonatomic) MCNearbyServiceBrowser *nearbyServiceBrowser;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *nearbyServiceAdvertiser;

@property (weak, nonatomic) IBOutlet UILabel *label_Model;
@property (weak, nonatomic) IBOutlet UISwitch *switch_Server;
@property (weak, nonatomic) IBOutlet UILabel *label_Server;

@property (weak, nonatomic) IBOutlet UILabel *label_LoModel_1;
@property (weak, nonatomic) IBOutlet UILabel *label_LoModel_2;
@property (weak, nonatomic) IBOutlet UILabel *label_LoModel_3;

//@property (weak, nonatomic) IBOutlet UILabel *labelMyPeerIDIPHONE;
//@property (weak, nonatomic) IBOutlet UILabel *labelYourPeerIDIPHONE;
//@property (weak, nonatomic) IBOutlet UILabel *labelMyPeerIDIPAD;
//@property (weak, nonatomic) IBOutlet UILabel *labelYourPeerIDIPAD;
//
//- (IBAction)btnStartAdvertisingIPHONE:(id)sender;
//- (IBAction)btnStartAdvertisingIPAD:(id)sender;
//- (IBAction)btnStopAdvertisingIPHONE:(id)sender;
//- (IBAction)btnStopAdvertisingIPAD:(id)sender;
//- (IBAction)btnStartBrowsingIPHONE:(id)sender;
//- (IBAction)btnStopBrowsingIPHONE:(id)sender;
//- (IBAction)btnStartBrowsingIPAD:(id)sender;
//- (IBAction)btnStopBrowsingIPAD:(id)sender;


// --------------------
// MCNearbyServiceBrowserDelegate
// --------------------

// Error Handling Delegate Methods

// browser:didNotStartBrowsingForPeers:
// Called when a browser failed to start browsing for peers. (required)
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error;

// Peer Discovery Delegate Methods

// browser:foundPeer:withDiscoveryInfo:
// Called when a new peer appears. (required)
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;

// browser:lostPeer:
// Called when a peer disappears. (required)
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID;


// --------------------
// MCNearbyServiceAdvertiserDelegate
// --------------------

// Error Handling Delegate Methods

// advertiser:didNotStartAdvertisingPeer:
// Called when advertisement fails. (required)
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error;

// Invitation Handling Delegate Methods

// advertiser:didReceiveInvitationFromPeer:withContext:invitationHandler:
// Called when a remote peer invites the app to join a session. (required)
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler;


// --------------------
// MCSessionDelegate
// --------------------

// MCSession Delegate Methods

// session:didReceiveData:fromPeer:
// Called when a remote peer sends an NSData object to the local peer. (required)
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;

// session:didStartReceivingResourceWithName:fromPeer:withProgress:
// Called when a remote peer begins sending a file-like resource to the local peer. (required)
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress;

// session:didFinishReceivingResourceWithName:fromPeer:atURL:withError:
// Called when a remote peer sends a file-like resource to the local peer. (required)
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error;

// session:didReceiveStream:withName:fromPeer:
// Called when a remote peer opens a byte stream connection to the local peer. (required)
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID;

// session:peer:didChangeState:
// Called when the state of a remote peer changes. (required)
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;

// session:didReceiveCertificate:fromPeer:certificateHandler:
// Called to authenticate a remote peer when the connection is first established. (required)
- (BOOL)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler;

@end