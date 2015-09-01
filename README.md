# JAHPeerConnection

## What is this?

A block-based API (and a nicer `init` method) for RTCPeerConnection from [webrtc.org](http://www.webrtc.org/). I've [submitted the same API](https://webrtc-codereview.appspot.com/26329004/) to the WebRTC project, but it hasn't been merged yet and I want this API for other projects without making a custom build. 

## Usage

I've added a nicer `init` method that provides some default constraints.

```objective-c
JAHPeerConnection* peerConnection = [[TLKPeerConnection alloc] initWithICEServers:servers constraints:constraints peerConnectionFactory:peerConnectionFactory];
peerConnection.delegate = self;
```

The delegate-based API has been replaced with a blocks-based API.

```objective-c
[self.peerConnection createOfferWithConstraints:constraints completion:^(RTCSessionDescription *sessionDescription, NSError *error) {
	// Do other stuff now that we have the offer
}];
```

## License

MIT

## Created By

This was created by [@hjon](http://twitter.com/hjon).
