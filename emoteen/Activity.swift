//
//  Activity.swift
//  emoteen
//
//  Created by Douglas Purdy on 6/13/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI
import CalendarKit
import SwiftyJSON

struct ActivityView: View {
    
    var records : [EmoRecord]
    
    var body: some View {
        
        NavigationView
            {
                VStack {
                    CalendarController(records: records)
                }
                .navigationBarTitle("Activity", displayMode: .inline)
                }
                
        .font(.title)
                

    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        //ActivityView(records: EmoRecords.)
        VStack { Spacer() }
    }
}




final class CalendarController: UIViewControllerRepresentable, EventDataSource {
    
    typealias UIViewControllerType = DayViewController
    
    public var records : [EmoRecord] = []
    
    init(records: [EmoRecord])
    {
        self.records = records
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DayViewController {
        let dayViewController = DayViewController()
        dayViewController.dataSource = self
        return dayViewController
    }
    
    func eventsForDate(_ date: Date)  -> [EventDescriptor] {
        return getMeditationDates() + getJournalDates()
    }
        
    func updateUIViewController(_ uiViewController: DayViewController, context: Context) {
        
    }
    
    func getMeditationDates() -> [EventDescriptor] {
        
        var events = [Event]()
        
        let event = Event()
        
        events.append(event)
        
        return events
    }

    func getJournalDates() -> [EventDescriptor] {
        
        var events = [Event]()
        
        let event = Event()
        
        events.append(event)
        
        return events
    }

    
    class Coordinator: NSObject {
        var parent: CalendarController
        
        init(_ calendarController: CalendarController) {
            self.parent = calendarController
        }
        
        
    }
}
