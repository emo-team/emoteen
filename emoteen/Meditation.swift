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
    var Started = Date()
    var Ended = Date()
    
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
    
    static func load() -> [Meditation]
    {
        return [Meditation("Anger", "hand.raised.fill", "http://media.zendo.tools/emoteen/anger.m4v"),
                Meditation("Stress", "burn", "http://media.zendo.tools/emoteen/stress.m4v"),
                Meditation("Anxious", "tornado", "http://media.zendo.tools/emoteen/anxious.m4v"),
                Meditation("Blah", "tortoise", "http://media.zendo.tools/emoteen/blah.m4v"),
                Meditation("Restless", "moon.zzz", "http://media.zendo.tools/emoteen/restless.m4v"),
                Meditation("About", "person", "http://media.zendo.tools/emoteen/about.m4v")]
    }
    
    var description : String {
        return "\(Title)\r\n\(Started)\r\n\(Ended)"
    }
    
    static var containerUrl: URL?
    {
          return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
      
    func save()
    {
        self.Ended = Date()
        
        if let url = Self.containerUrl, !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
              do {
                  try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
              }
              catch {
                  print(error.localizedDescription)
              }
          }
          
        let file = Self.containerUrl!.appendingPathComponent("\(self.Started.emoDate)" + ".emo")
          
        try! self.description.write(to: file, atomically: true, encoding: .utf8)
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
                self.save()
            }
            Button(self.play ? "Pause" : "Play") {
                self.play.toggle()
            }
        }
        
    }
    
    func save()
    {
        if FileManager.default.ubiquityIdentityToken != nil
        {
            print("save the meditation here.")
            
            meditation.save()
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

