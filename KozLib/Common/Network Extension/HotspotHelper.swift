//
//  HotspotHelper.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation
import NetworkExtension

class HotspotHelper {
  
  /*
   Source Article: https://mobiarch.wordpress.com/2016/11/02/working-with-nehotspothelper/
   */
  
  /*
   The purpose of the authentication API is to implement custom application level logic to authenticate the connection to a WIFI hotspot. This authentication is a two step process:
   
      1) First connect to the hotspot providing the hotspot’s password.
      2) Then perform custom authentication. For example, this can involve communicating with a server and passing additional credentials.
   
   There are three command types that you need to be aware of to perform custom authentication.
   
   NEHotspotHelperCommandType.filterScanList – iOS will call your closure with this command type when the user opens the WIFI Settings page. You can obtain a list of all available hotspots from the command. Your code needs to create a filtered list of hotspots that you will like to authenticate with. You also need to set the WIFI password for these hotspots at this point. Once the closure returns, iOS will show the display name below the filtered hotspots. The display name is set using the kNEHotspotHelperOptionDisplayName option as shown in the code above. Note: Filtering does not really remove other hotspots from the list in the WIFI settings page. It is simply meant to identify the networks that your app deems appropriate for authentication.
   
   NEHotspotHelperCommandType.evaluate – If the user taps on one of your filtered hotspots and makes a connection the closure is called again with an evaluate command. You can perform custom business logic to evaluate the connected hotspot. If it is appropriate, your code should set a high confidence level for the network.
   
   NEHotspotHelperCommandType.authenticate – After the evaluation phase the closure is called again with an authenticate command. Your code can now perform custom authentication logic and respond with a success or failure status. If successful the connection is finally established.
   */
  
  func test() {
    
    let options: [String: NSObject] = [kNEHotspotHelperOptionDisplayName : "Join this WIFI" as NSObject]
    let queue: DispatchQueue = DispatchQueue(label: "com.mobiarch", attributes: DispatchQueue.Attributes.concurrent)
    
    print("Started wifi scanning.")
    
    NEHotspotHelper.register(options: options, queue: queue) { (cmd: NEHotspotHelperCommand) in
      print("Received command: \(cmd.commandType.rawValue)")
      print("Network: \(cmd.network?.bssid ?? "nil")")
      print("Network List: \(cmd.networkList?.count ?? 0)")
      for network in cmd.networkList ?? [] {
        print("   - \(network.bssid)")
      }
    }
  }
}
