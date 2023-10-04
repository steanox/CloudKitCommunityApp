//
//  CloudKitCommunityAppApp.swift
//  CloudKitCommunityApp
//
//  Created by octavianus on 19/09/23.
//

import SwiftUI

@main
struct CloudKitCommunityAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    //CKContainer(identifier: <#T##String#>).accountStatus(completionHandler: <#T##(CKAccountStatus, Error?) -> Void#>)
                    CloudKitConfiguration.shared.container.accountStatus { status, error in
                        
                        
                        print(status)
                        
                    }
                }
                .environmentObject(CommunityManager())
        }
    }
}
