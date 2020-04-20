//
//  Journal.swift
//  emoteen8
//
//  Created by Lana on 2/21/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI
import UIKit

extension Date
{
    var emoDate : String
    {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd'@'HH.mm"
            return formatter.string(from: self)
        }
    }
}

class Journal : Identifiable, ObservableObject
{

    @Published var Title: String = ""
    @Published var Body: String = ""
    var ID: UUID = UUID()
    var Created = Date()
    
    init(_ title: String, _ body: String )
    {
        self.Title = title
        self.Body = body
    }
    
    init(_ filename: String)
    {
        self.Title = filename
        
        let file = Self.containerUrl!.appendingPathComponent(filename)
        
        let data = FileManager.default.contents(atPath: file.path)
        
        self.Body = String(data: data!, encoding: .utf8) ?? ""
        
    }
    
    var description : String {
        return "\(Title)\r\n\(Body)"
    }
    
    static var containerUrl: URL?
    {
        return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    func save()
    {
        if let url = Self.containerUrl, !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        let file = Self.containerUrl!.appendingPathComponent("\(self.Title)")
        
        print(self.description)
        
        try! self.Body.write(to: file, atomically: true, encoding: .utf8)
    }
    
    static func load() -> [Journal]
    {
        var journals = [Journal]()
        let files = try! FileManager.default.contentsOfDirectory(atPath: Self.containerUrl!.path)
    
        for file in files
        {
            if(file.contains(".emo") && !file.starts(with: "."))
            {
                journals.append(Journal(file))
            }
        }
        
        if journals.count == 0
        {
            let Title = "Welcome.emo"
            let Body =
            """
                   # emoteen: teens meditate on emotive states

                   ## ios app
                   ### mediations: ig stories / snaps of useful meditations. by teens, for teens, for free.
                   ### journals: your stories. private to you. or not.
                   ### mirrors: your stats, your friends, your teachers,

                   join us :): or not.
                   """
                   
            let journal = Journal(Title, Body)
            
            journals.append(journal)
            
        }
        
        return journals
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
            TextView(text: $journal.Body)

        }.onDisappear()
        {
            self.journal.save()
        }.navigationBarTitle(journal.Title)
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

struct Journal_Previews: PreviewProvider {
    
    static var body = """
    # emoteen
    teens meditate on emotive states

    ## ios app
    ### mediations: ig stories / snaps of useful meditations. by teens, for teens, for free.
    ### journals: your stories. private to you. or not.
    ### mirrors: your stats, your friends, your teachers,

    join us :): or not.
    """
    
    static var previews: some View {
        JournalView(Journal("#emoteen", body))
    }
}
