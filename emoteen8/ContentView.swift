//
//  ContentView.swift
//  emoteen8
//
//  Created by Lana on 2/21/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI

let testJournal = getTestJournal()

func getTestJournal() -> [Journal] {
    
    let journal = Journal()
    journal.Title = "Title1"
    journal.Body = "Body"
    
    let journal2 = Journal()
    journal2.Title = "Title2"
    journal2.Body = "Body"
    
    return [journal, journal2]
}

let testMeditation = getTestMeditations()

func getTestMeditations() -> [Meditation]
{
    let mediation = Meditation()
    mediation.Title = "Meditation 101"
    
    let mediation2 = Meditation()
    mediation2.Title = "About Lana Purdy"
    
    return [mediation, mediation2]
    
}

struct ContentView: View {
    
    @State private var selection = 0
    
    var body: some View
    {
        TabView(selection: $selection)
        {
            Text("Meditate")
                
                .tabItem {
                    VStack {
                        Image(systemName: "heart")
                        Text("Meditation")
                    }
            }
            .tag(0)
            
            NavigationView
                {
                    List(testJournal) {
                        journal in                        NavigationLink(destination: JournalView(journal: journal))
                        {
                            Text(journal.Title)
                        }
                    }
                    .navigationBarTitle("Activity")
                    .navigationBarItems(trailing:
                        
                        Button(action: {
                            print("Help tapped!")
                        }) {
                            VStack {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                        
                    )
            }
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "list.dash")
                    Text("Activity")
                }
            }
            .tag(1)
            
            Text("Profile")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
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
