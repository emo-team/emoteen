//
//  Journal.swift
//  emoteen8
//
//  Created by Lana on 2/21/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI
import UIKit

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
    
}

struct JournalView : View
{
    @ObservedObject var journal: Journal
    
    var body: some View {
        //ScrollView {
            VStack {
                TextView(text: $journal.Body)
            }
        //}
        
    }
    
}

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
           let view = UITextView()
            view.isScrollEnabled = true
            view.isEditable = true
            view.isUserInteractionEnabled = true
            view.contentInset = UIEdgeInsets(top: 5,
                left: 10, bottom: 5, right: 5)
            view.isHidden = false
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
        JournalView(journal: Journal("#emoteen", body))
    }
}
