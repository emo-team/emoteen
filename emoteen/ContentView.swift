//
//  ContentView.swift
//  emoteen8
//
//  Created by Lana on 2/21/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI
import QGrid
import Files

let testJournal = getTestJournal()

func getTestJournal() -> [Journal] {
    
   
    var Title = "Welcome :(:"
    var Body = """
    # emoteen
    teens meditate on emotive states

    ## ios app
    ### mediations: ig stories / snaps of useful meditations. by teens, for teens, for free.
    ### journals: your stories. private to you. or not.
    ### mirrors: your stats, your friends, your teachers,

    join us :): or not.
    """
    
     let journal = Journal(Title, Body)
    
    //let journal2 = getJournalsForFiles()
    
    
    var containerUrl: URL? {
        return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    // check for container existence
    if let url = containerUrl, !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    //let file = getDocumentsDirectory().appendingPathComponent("welcome.emo")
    let file = containerUrl!.appendingPathComponent("welcome.emo")
    
    print(file.description)
    
    
    
    file.startAccessingSecurityScopedResource()
    
   // if(file.startAccessingSecurityScopedResource()) {
    
        try! journal.Body.write(to: file, atomically: true, encoding: .utf8)
        let input = try! String(contentsOf: file)
        print(input)
        
     //   file.stopAccessingSecurityScopedResource()
    //}
    
    print(try! getDocuments())
    
    return [journal]
}


func getDocuments() throws -> [String]
{
    return try! FileManager.default.contentsOfDirectory(atPath: getDocumentsDirectory().path)
}

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}

let testMeditation = getTestMeditations()

func getTestMeditations() -> [Meditation]
{
    return [Meditation("Anger", "hand.raised.fill", "http://media.zendo.tools/emoteen/anger.m4v"),
            Meditation("Stress", "burn", "http://media.zendo.tools/emoteen/stress.m4v"),
            Meditation("Anxious", "tornado", "http://media.zendo.tools/emoteen/anxious.m4v"),
            Meditation("Blah", "tortoise", "http://media.zendo.tools/emoteen/blah.m4v"),
            Meditation("Restless", "moon.zzz", "http://media.zendo.tools/emoteen/restless.m4v"),
            Meditation("About", "person", "http://media.zendo.tools/emoteen/about.m4v")]
}

struct ContentView: View {
    
    @State private var selection = 0
    
    var body: some View
    {
        TabView(selection: $selection)
        {
            NavigationView {
                QGrid(testMeditation, columns: 2)
                {
                    meditation in
                    
                    NavigationLink(destination: MeditationDetailView(meditation: meditation))
                    {
                        VStack {
                            MeditationView(meditation: meditation)
                            Spacer()
                        }
                    }
                    
                }
                .navigationBarTitle("Meditations", displayMode: .inline)
            }
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
                        
                        journal in
                        
                        NavigationLink(destination: JournalView(journal: journal))
                        {
                            Text(journal.Title)
                        }
                    }
                    .navigationBarTitle("Activity", displayMode: .inline)
                    .navigationBarItems(trailing:
                        //NavigationLink {
                        Button(action: {
                            print("Help tapped!")
                    
                            
                        }) {
                            VStack {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                            //}
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
