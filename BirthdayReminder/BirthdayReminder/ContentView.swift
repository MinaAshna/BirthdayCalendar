//
//  ContentView.swift
//  BirthdayReminder
//
//  Created by Mina Ashna on 11/05/2023.
//

import SwiftUI
import EventKit

struct ContentView: View {
    @State var events: [EKEvent]? = nil
    
    var body: some View {
        VStack {
            List {
                if let events = events {
                    ForEach(events, id: \.self) { event in
                        
                        let _ = print(event.title)
                        if event.birthdayContactIdentifier != nil {
                            HStack {
                                Text(event.title)
                                Spacer()
                                Text(event.occurrenceDate,
                                     format: .dateTime.month().day())
                            }
                        }
                    }
                }
            }
            
        }
        .padding()
        .onAppear(perform: readEvents)
    }
    
    func readEvents() {
        let calendar = Calendar.current
        let store = EKEventStore()
        
        store.requestAccess(to: .event) { granted, error in
            guard granted else {
                print(error?.localizedDescription ?? "Permission to access calendar is not granted.")
                return
            }
            // Create the start date components
            var oneDayAgoComponents = DateComponents()
            oneDayAgoComponents.day = -1
            let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)
            
            // Create the end date components
            let tomorrowComponent = DateComponents()
            oneDayAgoComponents.day = 2
            let tomorrow = calendar.date(byAdding: tomorrowComponent, to: Date(), wrappingComponents: false)
            
            // Create the end date components.
            var oneYearFromNowComponents = DateComponents()
            oneYearFromNowComponents.year = 1
            let oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: Date(), wrappingComponents: false)
            
            // Create the predicate from the event store's instance method.
            var predicate: NSPredicate? = nil
            if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
                predicate = store.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
            }
            
            // Fetch all events that match the predicate.
            if let aPredicate = predicate {
                events = store.events(matching: aPredicate)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
