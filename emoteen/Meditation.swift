//
//  Meditation.swift
//  emoteen8
//
//  Created by Lana Purdy on 3/17/20.
//  Copyright © 2020 Lana Purdy. All rights reserved.
//

import SwiftUI
import VideoPlayer

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
        return [Meditation("Anger", "hand.raised.fill", "http://media.zendo.tools/emoteen/anger.m4v"),
                Meditation("Stress", "burn", "http://media.zendo.tools/emoteen/stress.m4v"),
                Meditation("Anxious", "tornado", "http://media.zendo.tools/emoteen/anxious.m4v"),
                Meditation("Blah", "tortoise", "http://media.zendo.tools/emoteen/blah.m4v"),
                Meditation("Restless", "moon.zzz", "http://media.zendo.tools/emoteen/restless.m4v"),
                Meditation("About", "person", "http://media.zendo.tools/emoteen/about.m4v")]
    }
     

}

struct MeditationView : View
{
    @ObservedObject var meditation: Meditation
    
    var body: some View {
        VStack {
            Image(systemName: meditation.thumbnailUrl).resizable().scaledToFit().frame(width: 166, height: 166)
            Text(meditation.title).font(.largeTitle)
        }
    }
    
}

struct MeditationDetailView : View {

    @ObservedObject var meditation: Meditation
    @State private var play: Bool = true
    
    func getUrl() -> URL
    {
        return URL(string: meditation.contentUrl)!
    }
    
    var body: some View {
        
        VStack
        {
            VideoPlayer(url: self.getUrl(), play: $play).autoReplay(true).onStateChanged { state in
                switch state {
                case .loading:
                    print("loading")
                case .playing(let totalDuration):
                    print(totalDuration)
                case .paused(let playProgress, let bufferProgress):
                   print(playProgress)
                case .error(let error):
                    print(error.description)
                }
            }.onDisappear() {
                self.play.toggle()
                self.save()
            }.onAppear() {
                self.meditation.created = Date()
            }
            Button(self.play ? "Pause" : "Play") {
                self.play.toggle()
            }
        }
        
    }
    
    func save()
    {
        meditation.save()
    }
}
