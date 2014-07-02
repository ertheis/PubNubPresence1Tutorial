//
//  ViewController.swift
//  PubNubPresence1Tutorial
//
//  Created by Eric Theis on 7/1/14.
//  Copyright (c) 2014 PubNub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var myConfig = PNConfiguration(forOrigin: "pubsub.pubnub.com", publishKey: "demo", subscribeKey: "demo", secretKey: nil)
        PubNub.setConfiguration(myConfig)
        var uuid = "littlerobertanthony48"
        PubNub.setClientIdentifier(uuid)
        PubNub.connect()
        
        let myChannel = PNChannel.channelWithName("realtimeAwardsShow", shouldObservePresence: false) as PNChannel
        
        PNObservationCenter.defaultCenter().addClientConnectionStateObserver(self) { (origin: String!, connected: Bool!, error: PNError!) in
            if connected {
                println("OBSERVER: Successful Connection!");
                PubNub.requestParticipantsListForChannel(myChannel) { (list: Array<AnyObject>!, channel: PNChannel!, error: PNError!) in
                    println("BLOCK: Requested Here_Now on Channel: \(channel), \(list)")
                }
                
                PubNub.subscribeOnChannel(myChannel, withClientState:
                    ["age": "67",
                        "full": "Robert Plant",
                        "country": "UK",
                        "appstate": "logged out",
                        "latlong": "51.5072° N, 0.1275° W"])
                
                
            } else {
                println("OBSERVER: \(error.localizedDescription), Connection Failed!");
            }
        }
        
        PNObservationCenter.defaultCenter().addClientChannelSubscriptionStateObserver(self) { (state: PNSubscriptionProcessState, channels: AnyObject[]!, error: PNError!) in
            switch state {
            case PNSubscriptionProcessState.SubscribedState:
                println("OBSERVER: Subscribed to Channel: \(channels[0])")
            case PNSubscriptionProcessState.NotSubscribedState:
                println("OBSERVER: Not subscribed to Channel: \(channels[0]), Error: \(error)")
            case PNSubscriptionProcessState.WillRestoreState:
                println("OBSERVER: Will re-subscribe to Channel: \(channels[0])")
            case PNSubscriptionProcessState.RestoredState:
                println("OBSERVER: Re-subscribed to Channel: \(channels[0])")
            default:
                println("OBSERVER: Something went wrong :(")
            }
        }
        
        PNObservationCenter.defaultCenter().addChannelParticipantsListProcessingObserver(self) { (list: AnyObject[]!, channel: PNChannel!, error: PNError!) in
            println("OBSERVER: addChannelParticipantsListProcessingObserver: list: \(list), on Channel: \(channel)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

