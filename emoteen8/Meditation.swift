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
    
    @Published var Title: String = ""
    @Published var Description: String = ""
    @Published var ContentUrl: String = ""
    @Published var ThumbnailUrl: String = ""
    
    var ID: UUID = UUID()
    var Created = Date()
    
    init(_ title: String, _ thumbnailUrl: String)
    {
        self.Title = title
        self.ThumbnailUrl = thumbnailUrl
    }
    
    init(_ title: String, _ thumbnailUrl: String, _ contentUrl: String)
    {
        self.Title = title
        self.ThumbnailUrl = thumbnailUrl
        self.ContentUrl = contentUrl
    }

}

struct MeditationView : View
{
    @ObservedObject var meditation: Meditation
    
    var body: some View {
        VStack {
            Image(systemName: meditation.ThumbnailUrl).resizable().scaledToFit().frame(width: 166, height: 166)
            Text(meditation.Title).font(.largeTitle)
        }
    }
    
}

struct MeditationDetailView : View {

    @ObservedObject var meditation: Meditation
    @State private var play: Bool = true
    
    func getUrl() -> URL
    {
        return URL(string: meditation.ContentUrl)!
    }
    
    var body: some View {
        
        VStack {
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
            }
            Button(self.play ? "Pause" : "Play") {
                self.play.toggle()
            }
        }
        
    }
}

struct Meditation_Preview: PreviewProvider {
    static var previews: some View {
        MeditationView(meditation: Meditation("Anger", "hand.raised.fill", "http://d2vg5ncbjf4s8e.cloudfront.net/hrv101.1.mp4"))
    }
}

struct MeditationDetail_Preview: PreviewProvider {
    static var previews: some View {
        MeditationDetailView(meditation: Meditation("Anger", "hand.raised.fill", "http://d2vg5ncbjf4s8e.cloudfront.net/hrv101.1.mp4"))
    }
}

