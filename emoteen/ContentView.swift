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
import AVFoundation

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
            
            JournalNavigationView()
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

class Experience
{
    static var player : AVAudioPlayer? = nil
    
    static func playMeditationBackground()
    {
        self.player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: "https://t4.bcbits.com/stream/83306e52f6b424d5f30a912fb59894fe/mp3-128/4078898188?p=0&ts=1596272231&t=baf0f0c8db8bc8eb42786e14246999e7dd95b489&token=1596272231_7cf817a1ae7eb37d43684d4ecbd2fc2d19ed895d  "))
        
        player?.prepareToPlay()
        player?.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
