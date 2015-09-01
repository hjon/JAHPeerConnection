//
//  JAHPeerConnection.h
//
//  Copyright (c) 2015 Jon Hjelle. All rights reserved.
//

@import Foundation
#import "RTCPeerConnection.h"

@class RTCPeerConnectionFactory;

@protocol JAHPeerConnectionDelegate;


@interface JAHPeerConnection : NSObject

@property (nonatomic, weak) id<JAHPeerConnectionDelegate> delegate;

- (instancetype)initWithICEServers:(NSArray*)servers constraints:(RTCMediaConstraints*)constraints peerConnectionFactory:(RTCPeerConnectionFactory*)peerConnectionFactory;

@end


@protocol JAHPeerConnectionDelegate <NSObject>
- (void)peerConnection:(JAHPeerConnection*)peerConnection signalingStateChanged:(RTCSignalingState)stateChanged;
- (void)peerConnection:(JAHPeerConnection*)peerConnection addedStream:(RTCMediaStream*)stream;
- (void)peerConnection:(JAHPeerConnection*)peerConnection removedStream:(RTCMediaStream*)stream;
- (void)peerConnectionOnRenegotiationNeeded:(JAHPeerConnection*)peerConnection;
- (void)peerConnection:(JAHPeerConnection*)peerConnection iceConnectionChanged:(RTCICEConnectionState)newState;
- (void)peerConnection:(JAHPeerConnection*)peerConnection iceGatheringChanged:(RTCICEGatheringState)newState;
- (void)peerConnection:(JAHPeerConnection*)peerConnection gotICECandidate:(RTCICECandidate*)candidate;
- (void)peerConnection:(JAHPeerConnection*)peerConnection didOpenDataChannel:(RTCDataChannel*)dataChannel;
@end
