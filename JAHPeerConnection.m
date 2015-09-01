//
//  JAHPeerConnection.m
//
//  Copyright (c) 2015 Jon Hjelle. All rights reserved.
//

#import "JAHPeerConnection.h"
#import "RTCSessionDescriptionDelegate.h"
#import "RTCPeerConnectionFactory.h"
#import "RTCMediaConstraints.h"
#import "RTCPair.h"

@interface JAHPeerConnection () <RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate>
@property (nonatomic, strong) RTCPeerConnection *peerConnection;
@property (nonatomic, strong) NSMutableArray* operationBlocks;
@end


@implementation JAHPeerConnection

- (instancetype)initWithICEServers:(NSArray*)servers constraints:(RTCMediaConstraints*)constraints peerConnectionFactory:(RTCPeerConnectionFactory*)peerConnectionFactory {
	self = [super init];
	if (self) {
        if (!constraints) {
            RTCPair* sctpConstraint = [[RTCPair alloc] initWithKey:@"internalSctpDataChannels" value:@"true"];
            RTCPair* dtlsConstraint = [[RTCPair alloc] initWithKey:@"DtlsSrtpKeyAgreement" value:@"true"];
            constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:nil optionalConstraints:@[sctpConstraint, dtlsConstraint]];
        }

        _peerConnection = [peerConnectionFactory peerConnectionWithICEServers:servers constraints:constraints delegate:self];
        _operationBlocks = [NSMutableArray array];
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.peerConnection;
}

#pragma mark - Wrapper API

- (void)createOfferWithConstraints:(RTCMediaConstraints*)constraints completionHandler:(void (^)(RTCSessionDescription* sessionDescription, NSError* error))completionHandler {
    [self.operationBlocks addObject:completionHandler];
    [self.peerConnection createOfferWithDelegate:self constraints:constraints];
}

- (void)createAnswerWithConstraints:(RTCMediaConstraints*)constraints completionHandler:(void (^)(RTCSessionDescription* sessionDescription, NSError* error))completionHandler {
    [self.operationBlocks addObject:completionHandler];
    [self.peerConnection createAnswerWithDelegate:self constraints:constraints];
}

- (void)setLocalDescription:(RTCSessionDescription*)sdp completionHandler:(void (^)(NSError* error))completionHandler {
    [self.operationBlocks addObject:completionHandler];
    [self.peerConnection setLocalDescriptionWithDelegate:self sessionDescription:sdp];
}

- (void)setRemoteDescription:(RTCSessionDescription*)sdp completionHandler:(void (^)(NSError* error))completionHandler {
    [self.operationBlocks addObject:completionHandler];
    [self.peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:sdp];
}

#pragma mark - RTCSessionDescriptionDelegate methods

- (void)peerConnection:(RTCPeerConnection*)peerConnection didCreateSessionDescription:(RTCSessionDescription*)sdp error:(NSError*)error {
    void (^completion)(RTCSessionDescription* sessionDescription, NSError* error) = [self.operationBlocks firstObject];
    if (completion) {
        [self.operationBlocks removeObjectAtIndex:0];
        completion(sdp, error);
    }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection didSetSessionDescriptionWithError:(NSError*)error {
    void (^completion)(NSError* error) = [self.operationBlocks firstObject];
    if (completion) {
        [self.operationBlocks removeObjectAtIndex:0];
        completion(error);
    }
}

#pragma mark - RTCPeerConnectionDelegate methods

- (void)peerConnection:(RTCPeerConnection*)peerConnection signalingStateChanged:(RTCSignalingState)stateChanged {
    [self.delegate peerConnection:self signalingStateChanged:stateChanged];
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection addedStream:(RTCMediaStream*)stream {
    [self.delegate peerConnection:self addedStream:stream];
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection removedStream:(RTCMediaStream*)stream {
    [self.delegate peerConnection:self removedStream:stream];
}

- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection*)peerConnection {
    [self.delegate peerConnectionOnRenegotiationNeeded:self];
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection iceConnectionChanged:(RTCICEConnectionState)newState {
    [self.delegate peerConnection:self iceConnectionChanged:newState];
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection iceGatheringChanged:(RTCICEGatheringState)newState {
    [self.delegate peerConnection:self iceGatheringChanged:newState];
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection gotICECandidate:(RTCICECandidate*)candidate {
    [self.delegate peerConnection:self gotICECandidate:candidate];
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection didOpenDataChannel:(RTCDataChannel*)dataChannel {
    [self.delegate peerConnection:self didOpenDataChannel:dataChannel];
}

@end
