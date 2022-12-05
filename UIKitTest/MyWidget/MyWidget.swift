//
//  MyWidget.swift
//  MyWidget
//
//  Created by 마석우 on 2022/12/02.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), day: nil, month: nil, hasToken: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), day: nil, month: nil, hasToken: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        print("called")
        print(Date())
        
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 0, to: currentDate)!
        let policyDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        var timelingPolicy: TimelineReloadPolicy = .never
        
        var fetchedDay: Days? = nil
        var fetchedMonth: Days? = nil
        
        guard DataManager.shared.token != nil else {
            print("no token")
            let entry = SimpleEntry(date: entryDate, day: fetchedDay, month: fetchedMonth, hasToken: false)
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: timelingPolicy)
            completion(timeline)
            return
        }

        let group = DispatchGroup()
        
        group.enter()
        DataManager.shared.fetchDayData { result in
            switch result {
            case .success(let day):
                fetchedDay = day
                timelingPolicy = .after(policyDate)
                print("success day")
            default:
                break
            }
            group.leave()
        }
        group.enter()
        DataManager.shared.fetchMonthData { result in
            switch result {
            case .success(let month):
                fetchedMonth = month
                timelingPolicy = .after(policyDate)
                print("success month")
            default:
                break
            }
            group.leave()
        }
        group.notify(queue: .main) {
            let entry = SimpleEntry(date: entryDate, day: fetchedDay, month: fetchedMonth, hasToken: true)
            entries.append(entry)

            let timeline = Timeline(entries: entries, policy: timelingPolicy)
            completion(timeline)
        }
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let day: Days?
    let month: Days?
    let hasToken: Bool
}

struct TrackRunWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            TrackRunView(monthData: entry.month, dayData: entry.day)
        default:
            Text("hello world")
        }
    }
}

struct TimeScaleWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            TimeScaleView(monthData: entry.month, dayData: entry.day)
        default:
            Text("hello world")
        }
    }
}

struct CircularRingWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            CircularRingView(monthData: entry.month, dayData: entry.day)
        default:
            Text("hello")
        }
    }
}

struct TrackRunWidget: Widget {
    let kind: String = "TrackRunWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TrackRunWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My TrackRunWidget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryCircular])
    }
}

////@main
struct TimeScaleWidget: Widget {
    let kind: String = "TimeScaleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            print("Timescale")
            return TimeScaleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My TimeScaleWidget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryCircular])
    }
}

//@main
struct CircularRingWidget: Widget {
    let kind: String = "My CircularRingWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            print("Circular")
            return CircularRingWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryCircular])
    }
}

@main
struct MyWidgets: WidgetBundle {
    var body: some Widget {
        // ...(다른 위젯들)
        CircularRingWidget()
        TimeScaleWidget()
        TrackRunWidget()
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimeScaleWidgetEntryView(entry: SimpleEntry(date: Date(), day: nil, month: nil, hasToken: true))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            CircularRingWidgetEntryView(entry: SimpleEntry(date: Date(), day: nil, month: nil, hasToken: true))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            TrackRunWidgetEntryView(entry: SimpleEntry(date: Date(), day: nil, month: nil, hasToken: true))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }
}
