//
//  Activity.swift
//  emoteen
//
//  Created by Douglas Purdy on 6/13/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI
import CalendarKit

struct ActivityView: View {
    var body: some View {
        
        
        NavigationView
            {
                VStack {
                    CalendarController()
                }
                .navigationBarTitle("Activity", displayMode: .inline)
                }
                
        .font(.title)
                

    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}


final class CalendarController: UIViewControllerRepresentable, EventDataSource {
    
    typealias UIViewControllerType = DayViewController
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DayViewController {
        let imagePickerController = DayViewController()
        imagePickerController.dataSource = self
        return imagePickerController
    }
    
    func eventsForDate(_ date: Date)  -> [EventDescriptor] {
        var events = [Event]()
        return events
    }
        
    func updateUIViewController(_ uiViewController: DayViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        var parent: CalendarController
        
        init(_ imagePickerController: CalendarController) {
            self.parent = imagePickerController
        }
        
        
    }
}
