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

}

struct MeditationView : View
{
    @ObservedObject var meditation: Meditation
    
    var body: some View {
        
        Text(meditation.Title)
    }
    
}
