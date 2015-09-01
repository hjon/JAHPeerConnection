//
//  JAHPeerConnection.m
//
//  Copyright (c) 2015 Jon Hjelle. All rights reserved.
//

#import "JAHPeerConnection.h"
#import "RTCPeerConnectionFactory.h"
#import "RTCMediaConstraints.h"
#import "RTCPair.h"

@interface JAHPeerConnection () <RTCPeerConnectionDelegate>
@property (nonatomic, strong) RTCPeerConnection *peerConnection
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
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.peerConnection;
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
