//
//  Journal.swift
//  emoteen8
//
//  Created by Lana on 2/21/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI

class Journal : Identifiable, ObservableObject
{
    @Published var Title: String = ""
    @Published var Body: String = ""
    var ID: UUID = UUID()
    var Created = Date()
    
}

struct JournalView : View
{
    @ObservedObject var journal: Journal
    
    var body: some View {
        
        TextField(journal.Title, text: $journal.Body)
    }
    
}



