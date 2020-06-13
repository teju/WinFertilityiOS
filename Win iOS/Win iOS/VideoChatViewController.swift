//
//  VideoChatViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 11/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//
var MemberIDs = ""
var VideoRoomName = ""

import UIKit
import TwilioVideo

class VideoChatViewController: UIViewController, CameraSourceDelegate, RoomDelegate, RemoteParticipantDelegate, VideoViewDelegate {

    @IBOutlet weak var status_Lbl: UILabel!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var previewView: VideoView!
    @IBOutlet weak var cameraFlipBtnOutlet: UIButton!
    @IBOutlet weak var videoBtnOutlet: UIButton!
    @IBOutlet weak var micBtnOutlet: UIButton!
    @IBOutlet weak var endCallBtnOutlet: UIButton!
    
    static var currentInstance: VideoChatViewController?
    var classRefs: AnyObject! = nil
    var accessToken = "TWILIO_ACCESS_TOKEN"
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var remoteViews: VideoView?
    var dimensions:CMVideoDimensions = CMVideoDimensions()
    
    var roomName = VideoRoomName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MemberIDs)
        print(VideoRoomName)
        dimensions.width = Int32(self.remoteView.frame.size.height)
        dimensions.height = Int32(self.remoteView.frame.size.height)
        print(twilioTokenId)
        self.startPreview()
        self.connect()
        self.showVideoCallingView()
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.room!.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cameraflipBtnClick(_ sender: Any) {
        var newDevice: AVCaptureDevice?
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        print("Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    @IBAction func cameraEnabledBtnClick(_ sender: Any) {
        if (!localVideoTrack!.isEnabled) {
            localVideoTrack!.isEnabled = true
                self.videoBtnOutlet.setImage(UIImage(named: "icon-unmute-camera"), for: .normal)
        }else{
            self.videoBtnOutlet.setImage(UIImage(named: "disable-video-on"), for: .normal)
            localVideoTrack!.isEnabled = false
        }
    }
    @IBAction func micBtnClick(_ sender: Any) {
        if (self.localAudioTrack != nil) {
                   self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
                   // Update the button title
                   if (self.localAudioTrack?.isEnabled == true) {
                       self.micBtnOutlet.setImage(UIImage(named: "icon-unmute"), for: .normal)
                   } else {
                       self.micBtnOutlet.setImage(UIImage(named: "disable-mic-on"), for: .normal)//icon-unmute
                   }
               }
    }
    @IBAction func endCallBtnClick(_ sender: Any) {
        self.room!.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    func configure() {
        videoBtnOutlet.layer.cornerRadius = 22
        micBtnOutlet.layer.cornerRadius = 22
        endCallBtnOutlet.layer.cornerRadius = 22
    }
    func showRoomUI(inRoom: Bool) {
        self.micBtnOutlet.isHidden = !inRoom
        self.endCallBtnOutlet.isHidden = !inRoom
        UIApplication.shared.isIdleTimerDisabled = inRoom
        if #available(iOS 11.0, *) {
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }
    func cleanupRemoteParticipant() {
        if ((self.remoteParticipant) != nil) {
            if ((self.remoteParticipant?.videoTracks.count)! > 0) {
                let remoteVideoTrack = self.remoteParticipant?.remoteVideoTracks[0].remoteTrack
                remoteVideoTrack?.removeRenderer(self.remoteViews!)
                self.remoteViews?.removeFromSuperview()
                self.remoteViews = nil
            }
        }
        self.remoteParticipant = nil
    }
    func startPreview(){
        if PlatformUtils.isSimulator {
                    return
                }
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
                
                if (frontCamera != nil || backCamera != nil) {
                    // Preview our local camera track in the local video preview view.
                    camera = CameraSource(delegate: self)
                    localVideoTrack = LocalVideoTrack.init(source: camera!, enabled: true, name: "Camera")
                    
                    localVideoTrack!.addRenderer(self.previewView)
                    print("Video track created")
                    if (frontCamera != nil && backCamera != nil) {
                    }
                    camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                        if let error = error {
                            print("Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                        } else {
                            self.previewView.shouldMirror = (captureDevice.position == .front)
                        }
                    }
                }
                else {
                    print("No front or back capture device found!")
                }
    }
    func prepareLocalMedia() {
           // We will share local audio and video when we connect to the Room.
           // Create an audio track.
           if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
               if (localAudioTrack == nil) {
                print("Failed to create audio track")
               }
           }
           // Create a video track which captures from the camera.
           if (localVideoTrack == nil) {
               self.startPreview()
           }
       }
    func connect(){
       self.prepareLocalMedia()
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: twilioTokenId) { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use the preferred video codec
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = VideoRoomName
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        print("Attempting to connect to room \(VideoRoomName)")
        
        self.showRoomUI(inRoom: true)
    }
    func dissmissVC() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.removeFromSuperview()
        }, completion: { (completed) in
            VideoChatViewController.currentInstance = nil
        })
    }
    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        print("Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    func setupRemoteVideoView() {
            // Creating `TVIVideoView` programmatically
        self.remoteViews = VideoView.init(frame: CGRect.zero, delegate:self)
            self.remoteView.insertSubview(self.remoteViews!, at: 0)
            
            // `TVIVideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
            // scaleAspectFit is the default mode when you create `TVIVideoView` programmatically.
            self.remoteViews!.contentMode = .scaleAspectFill
   
//       let centerX = NSLayoutConstraint(item: self.remoteView!,
//                                         attribute: NSLayoutConstraint.Attribute.centerX,
//                                         relatedBy: NSLayoutConstraint.Relation.equal,
//                                         toItem: self.remoteView,
//                                         attribute: NSLayoutConstraint.Attribute.centerX,
//                                         multiplier: 1,
//                                         constant: 0);
//        self.remoteView.addConstraint(centerX)
//        let centerY = NSLayoutConstraint(item: self.remoteView!,
//                                         attribute: NSLayoutConstraint.Attribute.centerY,
//                                         relatedBy: NSLayoutConstraint.Relation.equal,
//                                         toItem: self.remoteView,
//                                         attribute: NSLayoutConstraint.Attribute.centerY,
//                                         multiplier: 1,
//                                         constant: 0);
//        self.remoteView.addConstraint(centerY)
//        let width = NSLayoutConstraint(item: self.remoteView!,
//                                       attribute: NSLayoutConstraint.Attribute.width,
//                                       relatedBy: NSLayoutConstraint.Relation.equal,
//                                       toItem: self.remoteView,
//                                       attribute: NSLayoutConstraint.Attribute.width,
//                                       multiplier: 1,
//                                       constant: 0);
//        self.remoteView.addConstraint(width)
//        let height = NSLayoutConstraint(item: self.remoteView!,
//                                        attribute: NSLayoutConstraint.Attribute.height,
//                                        relatedBy: NSLayoutConstraint.Relation.equal,
//                                        toItem: self.remoteView,
//                                        attribute: NSLayoutConstraint.Attribute.height,
//                                        multiplier: 1,
//                                        constant: 0);
//        self.remoteView.addConstraint(height)
        remoteViews!.centerXAnchor.constraint(equalTo: remoteView.centerXAnchor).isActive = true
        remoteViews!.centerYAnchor.constraint(equalTo: remoteView.centerYAnchor).isActive = true
        remoteViews!.widthAnchor.constraint(equalTo: remoteView.widthAnchor).isActive = true
        remoteViews!.heightAnchor.constraint(equalTo: remoteView.heightAnchor).isActive = true
        view.setNeedsLayout()
        }
}
extension VideoChatViewController {
    func didConnect(to room: Room) {
        self.status_Lbl.isHidden = true
        // At the moment, this example only supports rendering one Participant at a time.
      //   self.messageLabel.text = ""
        //print( "Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity))")
        if (room.remoteParticipants.count > 0) {
            self.remoteParticipant = room.remoteParticipants[0]
            self.remoteParticipant?.delegate = self
            
        }
        
        self.showVideoChatView()
    }
    
    func room(_ room: Room, didDisconnectWithError error: Error?) {
        self.status_Lbl.isHidden = false
        print("Disconncted from room \(room.name), error = \(String(describing: error))")
        self.cleanupRemoteParticipant()
        self.room = nil
        self.showRoomUI(inRoom: false)
    }
    
    func room(_ room: Room, didFailToConnectWithError error: Error) {
        self.status_Lbl.isHidden = false
        print("Failed to connect to room with error")
        self.room = nil
        self.showRoomUI(inRoom: false)
    }
    
    func room(_ room: Room, participantDidConnect participant: RemoteParticipant) {
        self.status_Lbl.isHidden = true
        if (self.remoteParticipant == nil) {
            self.remoteParticipant = participant
            self.remoteParticipant?.delegate = self
        }
        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
           // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
           let videoPublications = participant.remoteVideoTracks
           for publication in videoPublications {
               if let subscribedVideoTrack = publication.remoteTrack,
                   publication.isTrackSubscribed {
                   setupRemoteVideoView()
                   subscribedVideoTrack.addRenderer(self.remoteViews!)
                   self.remoteParticipant = participant
                   return true
               }
           }
           return false
       }
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
                renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.

        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    func room(_ room: Room, participantDidDisconnect participant: RemoteParticipant) {
        self.status_Lbl.isHidden = false
        if (self.remoteParticipant == participant) {
            cleanupRemoteParticipant()
        }
        print("Room \(room.name), Participant \(participant.identity) disconnected")
    }
}
extension VideoChatViewController  {
    func roomDidConnect(room: Room) {
        print( "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        self.status_Lbl.isHidden = false
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
    }

    func roomDidDisconnect(room: Room, error: Error?) {
        print( "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        
        self.showRoomUI(inRoom: false)
    }

    func roomDidFailToConnect(room: Room, error: Error) {
        print( "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        
        self.showRoomUI(inRoom: false)
    }

    func roomIsReconnecting(room: Room, error: Error) {
        print( "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }

    func roomDidReconnect(room: Room) {
        print( "Reconnected to room \(room.name)")
    }

    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        self.status_Lbl.isHidden = true
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self

        print( "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        self.status_Lbl.isHidden = false
        print( "Room \(room.name), Participant \(participant.identity) disconnected")

        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}
extension VideoChatViewController  {

    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        print( "Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.

        print( "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.

        print( "Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.

        print( "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        print( "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()

            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
                let index = remainingParticipants.index(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }

    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
       
        print( "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        print( "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print( "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }

    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print( "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }

    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print( "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print( "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        print( "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        print( "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK: TVIRemoteParticipantDelegate
extension VideoChatViewController {
    
    func remoteParticipant(_ participant: RemoteParticipant,
                           publishedVideoTrack publication: RemoteVideoTrackPublication) {
        self.status_Lbl.isHidden = true
        // Remote Participant has offered to share the video Track.
        print("Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: RemoteParticipant,
                           unpublishedVideoTrack publication: RemoteVideoTrackPublication) {
        
        // Remote Participant has stopped sharing the video Track.
        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: RemoteParticipant,
                           publishedAudioTrack publication: RemoteAudioTrackPublication) {
        
        // Remote Participant has offered to share the audio Track.
        print("Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipant(_ participant: RemoteParticipant,
                           unpublishedAudioTrack publication: RemoteAudioTrackPublication) {
        
        // Remote Participant has stopped sharing the audio Track.
        print("Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    func subscribed(to videoTrack: RemoteVideoTrack,
                    publication: RemoteVideoTrackPublication,
                    for participant: RemoteParticipant) {
        
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's video frames now.
        self.status_Lbl.isHidden = true
        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        if (self.remoteParticipant == participant) {
            setupRemoteVideoView()
            videoTrack.addRenderer(self.remoteViews!)
        }
    }
    
    func unsubscribed(from videoTrack: RemoteVideoTrack,
                      publication: RemoteVideoTrackPublication,
                      for participant: RemoteParticipant) {
        
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        print("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        if (self.remoteParticipant == participant) {
            videoTrack.removeRenderer(self.remoteViews!)
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
        }
    }
    
    func subscribed(to audioTrack: RemoteAudioTrack,
                    publication: RemoteAudioTrackPublication,
                    for participant: RemoteParticipant) {
        
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        print("Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func unsubscribed(from audioTrack: RemoteAudioTrack,
                      publication: RemoteAudioTrackPublication,
                      for participant: RemoteParticipant) {
        
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        print("Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipant(_ participant: RemoteParticipant,
                           enabledVideoTrack publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: RemoteParticipant,
                           disabledVideoTrack publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: RemoteParticipant,
                           enabledAudioTrack publication: RemoteAudioTrackPublication) {
        print("Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipant(_ participant: RemoteParticipant,
                           disabledAudioTrack publication: RemoteAudioTrackPublication) {
        print("Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func failedToSubscribe(toAudioTrack publication: RemoteAudioTrackPublication,
                           error: Error,
                           for participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func failedToSubscribe(toVideoTrack publication: RemoteVideoTrackPublication,
                           error: Error,
                           for participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK: TVIVideoViewDelegate
extension VideoChatViewController {
    func videoView(_ view: VideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
        self.remoteView.setNeedsLayout()
    }
}

// MARK: TVICameraSourceDelegate
extension VideoChatViewController {
    func cameraSource(_ source: CameraSource, didFailWithError error: Error) {
        print("Camera source failed with error: \(error.localizedDescription)")
    }
}
extension VideoChatViewController {
    private func showVideoChatView() {
      //  self.viewRating.isHidden = true
        //self.viewCalling.isHidden = true
        //self.viewVideoChat.isHidden = false
    }
    
    private func showVideoCallingView() {
       // self.viewRating.isHidden = true
        //self.viewCalling.isHidden = false
        //self.viewVideoChat.isHidden = true
    }
    
    private func showRatingView() {
       // self.viewRating.isHidden = false
        //self.viewCalling.isHidden = true
        //self.viewVideoChat.isHidden = true
    }
}



import TwilioVideo

class Settings: NSObject {

    let supportedAudioCodecs: [AudioCodec] = [IsacCodec(),
                                              OpusCodec(),
                                              PcmaCodec(),
                                              PcmuCodec(),
                                              G722Codec()]
    
    let supportedVideoCodecs: [VideoCodec] = [Vp8Codec(),
                                              Vp8Codec(simulcast: true),
                                              H264Codec(),
                                              Vp9Codec()]
    
    var audioCodec: AudioCodec?
    var videoCodec: VideoCodec?

    var maxAudioBitrate = UInt()
    var maxVideoBitrate = UInt()

    func getEncodingParameters() -> EncodingParameters?  {
        if maxAudioBitrate == 0 && maxVideoBitrate == 0 {
            return nil;
        } else {
            return EncodingParameters(audioBitrate: maxAudioBitrate,
                                         videoBitrate: maxVideoBitrate)
        }
    }
    
    private override init() {
        // Can't initialize a singleton
    }
    
    // MARK: Shared Instance
    static let shared = Settings()
}
