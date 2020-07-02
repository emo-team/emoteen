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

struct ActivityView: View
{
    var records : [EmoRecord]
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
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

final class CalendarController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DayViewController
    
    let dayViewController = DayViewController()
    public var records : [EmoRecord] = []
    
    init(records: [EmoRecord])
    {
        self.records = records
    }
    
    func makeCoordinator() -> Coordinator
    {
        let ctx = Coordinator(self)
        
        return ctx
    }
    
    func makeUIViewController(context: Context) -> DayViewController
    {
        dayViewController.dataSource = context.coordinator
        dayViewController.delegate = context.coordinator
        dayViewController.dayView.autoScrollToFirstEvent = true
        return dayViewController
    }
    
    
    func updateUIViewController(_ uiViewController: DayViewController, context: Context)
    {
        uiViewController.dataSource = context.coordinator
        uiViewController.delegate = context.coordinator
        dayViewController.dayView.autoScrollToFirstEvent = true
        dayViewController.dayView.reloadData()
    }
    
    class Coordinator: NSObject, EventDataSource, DayViewDelegate
    {
        func dayViewDidSelectEventView(_ eventView: EventView) {
            
        }
        
        func dayViewDidLongPressEventView(_ eventView: EventView) {
            
        }
        
        func dayView(dayView: DayView, didTapTimelineAt date: Date) {
            
        }
        
        func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
            
        }
        
        func dayViewDidBeginDragging(dayView: DayView) {
            
        }
        
        func dayView(dayView: DayView, willMoveTo date: Date) {
            
        }
        
        func dayView(dayView: DayView, didMoveTo date: Date) {
            
        }
        
        func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
            
        }
        
        var parent: CalendarController
        
        init(_ calendarController: CalendarController) {
            self.parent = calendarController
            
        }
        
        func move()
        {
    
        }
        
        func eventsForDate(_ date: Date)  -> [EventDescriptor]
        {
            var events = [Event]()
               
            for record : EmoRecord in EmoRecord.load()
            {
                    let event = Event()
                    event.startDate = record.Start
                    let date = record.Start + 30 * 60
                    event.endDate = date
                    event.text = record.Title + "\r\n" + record.EmoType + "\r\n" + record.Body
                    events.append(event)
            }
            
            return events
        
        }
    }
}
