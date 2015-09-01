//
//  JAHPeerConnection.h
//
//  Copyright (c) 2015 Jon Hjelle. All rights reserved.
//

@import Foundation;
#import "RTCPeerConnection.h"

@class RTCPeerConnectionFactory;

@protocol JAHPeerConnectionDelegate;


@interface JAHPeerConnection : NSObject

@property (nonatomic, weak) id<JAHPeerConnectionDelegate> delegate;

- (instancetype)initWithICEServers:(NSArray*)servers constraints:(RTCMediaConstraints*)constraints peerConnectionFactory:(RTCPeerConnectionFactory*)peerConnectionFactory;

- (void)createOfferWithConstraints:(RTCMediaConstraints*)constraints completionHandler:(void (^)(RTCSessionDescription* sessionDescription, NSError* error))completionHandler;
- (void)createAnswerWithConstraints:(RTCMediaConstraints*)constraints completionHandler:(void (^)(RTCSessionDescription* sessionDescription, NSError* error))completionHandler;
- (void)setLocalDescription:(RTCSessionDescription*)sdp completionHandler:(void (^)(NSError* error))completionHandler;
- (void)setRemoteDescription:(RTCSessionDescription*)sdp completionHandler:(void (^)(NSError* error))completionHandler;
- (BOOL)getStatsForMediaStreamTrack:(RTCMediaStreamTrack*)mediaStreamTrack statsOutputLevel:(RTCStatsOutputLevel)statsOutputLevel completionHandler:(void (^)(NSArray* stats))completionHandler;

@end


@interface JAHPeerConnection (RTCPeerConnectionForwards)
// Refer to RTCPeerConnection for details
@property(nonatomic, strong, readonly) NSArray* localStreams;
@property(nonatomic, assign, readonly) RTCSessionDescription* localDescription;
@property(nonatomic, assign, readonly) RTCSessionDescription* remoteDescription;
@property(nonatomic, assign, readonly) RTCSignalingState signalingState;
@property(nonatomic, assign, readonly) RTCICEConnectionState iceConnectionState;
@property(nonatomic, assign, readonly) RTCICEGatheringState iceGatheringState;

- (BOOL)addStream:(RTCMediaStream*)stream;
- (void)removeStream:(RTCMediaStream*)stream;
- (RTCDataChannel*)createDataChannelWithLabel:(NSString*)label config:(RTCDataChannelInit*)config;
- (BOOL)addICECandidate:(RTCICECandidate*)candidate;
- (BOOL)updateICEServers:(NSArray*)servers constraints:(RTCMediaConstraints*)constraints;
- (void)close;

@end


@protocol JAHPeerConnectionDelegate <NSObject>
// Refer to RTCPeerConnectionDelegate for details
- (void)peerConnection:(JAHPeerConnection*)peerConnection signalingStateChanged:(RTCSignalingState)stateChanged;
- (void)peerConnection:(JAHPeerConnection*)peerConnection addedStream:(RTCMediaStream*)stream;
- (void)peerConnection:(JAHPeerConnection*)peerConnection removedStream:(RTCMediaStream*)stream;
- (void)peerConnectionOnRenegotiationNeeded:(JAHPeerConnection*)peerConnection;
- (void)peerConnection:(JAHPeerConnection*)peerConnection iceConnectionChanged:(RTCICEConnectionState)newState;
- (void)peerConnection:(JAHPeerConnection*)peerConnection iceGatheringChanged:(RTCICEGatheringState)newState;
- (void)peerConnection:(JAHPeerConnection*)peerConnection gotICECandidate:(RTCICECandidate*)candidate;
- (void)peerConnection:(JAHPeerConnection*)peerConnection didOpenDataChannel:(RTCDataChannel*)dataChannel;
@end
