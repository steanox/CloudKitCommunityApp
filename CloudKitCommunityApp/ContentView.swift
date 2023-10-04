//
//  ContentView.swift
//  CloudKitCommunityApp
//
//  Created by octavianus on 19/09/23.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    
    @EnvironmentObject var communityManager: CommunityManager
    @State var isLoadingIndicatorShow: Bool = true
    @State var isAddSheetActive: Bool = false
    @State var isShareSheetShown: Bool = false
    
    
    
    
    var body: some View {
        ZStack{
            NavigationStack {
                List {
                    Section {
                        ForEach(communityManager.communities) { community in
                            HStack{
                                Text(community.name)
                                Button {
                                    
                                    
                                    Task{
                                        try await communityManager.share(community)
                                        isShareSheetShown = true
                                    }

                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                        }
                    } header: {
                        Text("Private")
                    }
                    
                    Section {
                        ForEach(communityManager.sharedCommunities) { community in
                            HStack{
                                Text(community.name)
                            }
                        }
                    } header: {
                        Text("Shared")
                    }


                }
                .navigationTitle("Communities")
                .toolbar {
                    Button {
                        isAddSheetActive = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            if isLoadingIndicatorShow{
                ProgressView().progressViewStyle(.circular)
            }
        }
        .sheet(isPresented: $isAddSheetActive) {
            AddNewCommunitySheet()
        }
        .sheet(isPresented: $isShareSheetShown) {
            if let share = communityManager.selectedSharedRecordCommunity{
                CloudSharingView(share: share)
            }
                
                
            
            
        }
        .onAppear{
            Task{
                try await CloudKitConfiguration.shared.createZoneIfNeeded()
                await communityManager.fetchAllCommunity()
                isLoadingIndicatorShow = false
            }
        }
        .refreshable {
            await communityManager.fetchAllCommunity()
        }


    }
}


struct AddNewCommunitySheet: View{
    
    @EnvironmentObject var communityManager: CommunityManager
    @Environment(\.dismiss) var dismiss
    @State var isLoadingShows = false
    @State var newCommunityName: String = ""
    
    var body: some View{
        VStack{
            Text("Add New Community")
            TextField("", text: $newCommunityName)
            Button {
                Task{
                    isLoadingShows = true
                    await communityManager.addNewCommunity(with: newCommunityName)
                    isLoadingShows = false
                    dismiss()
                }
            } label: {
                HStack{
                    if isLoadingShows{
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(height: 25)
                    }
                    Text("Add")
                }
                
            }.buttonStyle(.bordered)
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
