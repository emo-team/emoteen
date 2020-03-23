//
//  Meditation.swift
//  emoteen8
//
//  Created by Lana Purdy on 3/17/20.
//  Copyright © 2020 Lana Purdy. All rights reserved.
//

import SwiftUI

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

}

struct MeditationView : View
{
    @ObservedObject var meditation: Meditation
    
    var body: some View {
        HStack {
            Image(systemName: meditation.ThumbnailUrl).resizable().scaledToFit().frame(width: 100,height:100)
            Spacer()
            Text(meditation.Title).font(.largeTitle)
        }
    }
    
}
