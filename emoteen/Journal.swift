//
//  Journal.swift
//  emoteen8
//
//  Created by Lana on 2/21/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI
import UIKit

class Journal : Identifiable, ObservableObject, Hashable, Comparable
{
    var ID: UUID = UUID()
    var Record : EmoRecord

    static func < (lhs: Journal, rhs: Journal) -> Bool
    {
        return lhs.Record.Title < rhs.Record.Title
    }
    
    static func == (lhs: Journal, rhs: Journal) -> Bool
    {
        return lhs.Record.Title == rhs.Record.Title
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(Record.Title)
    }
    
    init(_ record : EmoRecord)
    {
        self.Record = record
    }
    
    init()
    {
        self.Record = EmoRecord(type: EmoType.Journal, title: Date().emoDate, body: "")
    }
    
    func save()
    {
        self.Record.save()
    }
    
    func delete()
    {
        self.Record.delete()
    }
    
    static func load() -> [Journal]
    {
        var journals = [Journal]()
        
        let records = EmoRecord.load()
        
        for record in records
        {
            if(record.EmoType.contains("journal"))
            {
                journals.append(Journal(record))
            }
        }
        
        if journals.count == 0
        {
            let Title = "Welcome.emo"
            let Body =
            """
                   # emoteen: teens meditate on emotive states

                   ## ios app
                   ### mediation: ig stories / snaps of useful meditations. by teens, for teens, for free.
                   ### journal: your stories. private to you. or not.
                   ### activity: your stats, over time.

                   join us :): or not.
                   """
            
            let journal = Journal(EmoRecord(type: EmoType.Journal, title: Title, body: Body))
            
            journals.append(journal)
            
        }
        
        return journals.sorted(by: >)
    }
    
}

struct JournalNavigationView: View
{
    @State var journals : [Journal]
    
    var body: some View
    {
        NavigationView
        {
                List
                {
                    ForEach(journals, id:\.self)
                    {
                        journal in
                    
                        NavigationLink(destination: JournalView(journal))
                        {
                            Text(journal.Record.Title)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationBarTitle("Journal", displayMode: .inline)
                .navigationBarItems(trailing:
                    NavigationLink(destination: JournalView(Journal()))
                    {
                        Image(systemName: "square.and.pencil")
                    })
                .onAppear(perform:
                {
                    self.journals = Journal.load()
                })
                
    
        }
        .font(.title)
    }
    
    func delete(at offsets: IndexSet)
    {
        let journal = journals[offsets.first!]
        
        journal.delete()
        
        journals.remove(atOffsets: offsets)
    }
}

struct JournalView : View
{
    @ObservedObject var journal: Journal
    
    init(_ journal: Journal)
    {
        self.journal = journal
    }
    
    var body: some View
    {
        VStack<TextView>
        {
            TextView(text: $journal.Record.Body)

        }.onDisappear()
        {
            self.journal.save()
        }
        .navigationBarTitle(journal.Record.Title)
    }
}

struct TextView: UIViewRepresentable
{
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
           let view = UITextView()
            view.isScrollEnabled = true
            view.isEditable = true
            view.isUserInteractionEnabled = true
            view.contentInset = UIEdgeInsets(top: 5,
                left: 10, bottom: 5, right: 5)
            view.isHidden = false
            view.delegate = context.coordinator
            view.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.medium)
            return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> TextView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var control: TextView
        
        init(_ control: TextView) {
            self.control = control
        }
        
        func textViewDidChange(_ textView: UITextView) {
            control.text = textView.text
        }
    }
}

