//
//  Meditation.swift
//  emoteen8
//
//  Created by Lana Purdy on 3/17/20.
//  Copyright © 2020 Lana Purdy. All rights reserved.
//

import SwiftUI
import VideoPlayer
import AVFoundation
import QGrid

class Meditation :  Identifiable, ObservableObject 
{
    @Published var title: String = ""
    @Published var contentUrl: String = ""
    @Published var thumbnailUrl: String = ""
    
    var ID: UUID = UUID()
    var created : Date? = nil
    
    init(_ title: String, _ thumbnailUrl: String)
    {
        self.title = title
        self.thumbnailUrl = thumbnailUrl
    }
    
    init(_ title: String, _ thumbnailUrl: String, _ contentUrl: String)
    {
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.contentUrl = contentUrl
    }
    
    func save()
    {
        let record = EmoRecord(self.title, "Meditation", self.contentUrl, self.created!, Date())
        
        record.save()
    }
    
    static func load() -> [Meditation]
    {
        return [Meditation("Anger", "anger", "http://media.zendo.tools/emoteen/anger.m4v"),
                Meditation("Stress", "stress", "http://media.zendo.tools/emoteen/stress.m4v"),
                Meditation("Anxious", "anxious", "http://media.zendo.tools/emoteen/anxious.m4v"),
                Meditation("Blah", "blah", "http://media.zendo.tools/emoteen/blah.m4v"),
                Meditation("Sleepy", "sleepy", "http://media.zendo.tools/emoteen/sleepy.m4v"),
                Meditation("About", "about", "http://media.zendo.tools/emoteen/about.m4v")]
    }
    
}

struct MeditationNavigationView: View
{
    let playMeditationBackgroundPlayer = Experience.playMeditationBackgroundPlayer()
    
    var body: some View
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
        }.onAppear()
        {
            if let player : AVPlayer = self.playMeditationBackgroundPlayer
            {
                player.play()
            }
        }.onDisappear() {
            if let player : AVPlayer = self.playMeditationBackgroundPlayer
            {
                player.pause()
            }
        }
    }
    
}

class Experience
{
    static var player : AVPlayer? = nil
    
    static func playMeditationBackgroundPlayer() -> AVPlayer?
    {
        if(Self.player == nil)
        {
            let urlString = "http://media.zendo.tools/emoteen/meditations.mov"
         
            guard let url = URL.init(string: urlString)
                else {
                    return nil
            }
            
            let playerItem = AVPlayerItem.init(url: url)
            Self.player = AVPlayer.init(playerItem: playerItem)
            Self.player?.play()
            
        }
        return player
    }
}

struct MeditationView : View
{
    @ObservedObject var meditation: Meditation
    
    var body: some View
    {
        
        VStack
            {
                Spacer(minLength: 20)
                Image(meditation.thumbnailUrl).renderingMode(.original).fixedSize()
                Text(meditation.title).font(.largeTitle)
                Spacer(minLength: 33)
        }
    }
    
}

struct MeditationDetailView : View {
    
    @State private var play: Bool = true
    @State private var time: CMTime = .zero
    @State private var currentPosition = 0.0
    @State private var duration: Double = .zero
    @ObservedObject var meditation: Meditation
    
    func getUrl() -> URL
    {
        return URL(string: meditation.contentUrl)! // + "?now=" + Date().emoDate)!
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                VideoPlayer(url: self.getUrl(), play: self.$play, time: self.$time)
                    .autoReplay(true)
                    .onPlayToEndTime {
                        
                }
                .onReplay {
                    self.currentPosition = 0
                }
                .onStateChanged { state in
                    switch state {
                    case .loading:
                        print("loading")
                    case .playing(let totalDuration):
                        self.duration = totalDuration
                        print("playing")
                    case .paused:
                        print("paused")
                    case .error(let error):
                        print(error.description)
                    
                    }
                }.onAppear() {
                    self.meditation.created = Date()
                    
                }.frame(maxWidth: .infinity).edgesIgnoringSafeArea(.all)
            }
        VStack {
                
            Button(action: { self.play.toggle() }) { Image(systemName: self.play ? "pause" : "play").resizable().frame(width: 33, height: 33, alignment: .center)
        
                .padding(.leading, 20)
            }
            
            let range = 0...self.duration
            
            let binding = Binding(
                get: { self.time.seconds },
                set: { self.time = CMTime(seconds: $0 , preferredTimescale: 100)  }
            )
            
            Slider(value: binding, in: range){
                _ in
                let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
                selectionFeedbackGenerator.selectionChanged()
            }.frame(width: 150, height: 100, alignment: .top)
        
        }
        }.onDisappear() {
            self.play = false
            self.save()
        }
    }
    
    func save()
    {
        meditation.save()
    }
}

struct Meditation_Previews: PreviewProvider {
    static var previews: some View {
        MeditationDetailView(meditation: Meditation("About", "about", "http://media.zendo.tools/emoteen/about.m4v"))
    }
}
