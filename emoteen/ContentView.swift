//
//  ContentView.swift
//  emoteen8
//
//  Created by Lana Purdy on 2/21/20.
//  Copyright © 2020 Lana Purdy. All rights reserved.
//

import SwiftUI
import QGrid
import Files

struct ContentView: View {
    
    @State private var selection = 0
    
    var body: some View
    {
        TabView(selection: $selection)
        {
            NavigationView {
                QGrid(Meditation.load(), columns: 2)
                {
                    meditation in
                    
                    NavigationLink(destination: MeditationDetailView(meditation: meditation))
                    {
                        MeditationView(meditation: meditation)
                            
                    }.buttonStyle(PlainButtonStyle())
                    
                }
                .navigationBarTitle("Meditation", displayMode: .inline)
            }
            .tabItem {
                VStack {
                    Image(systemName: "heart")
                    Text("Meditation")
                }
            }
            .tag(0)
            
            JournalNavigationView(journals: Journal.load())
            .tabItem {
                VStack {
                    Image(systemName: "list.dash")
                    Text("Journal")
                }
            }
            .tag(1)
            
            ActivityView(records: EmoRecord.load())
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Activity")
                    }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
