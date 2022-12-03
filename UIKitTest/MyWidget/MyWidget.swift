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
        let policyDate = Calendar.current.date(byAdding: .minute, value: 2, to: Date())!
        var timelingPolicy: TimelineReloadPolicy = .never
        
        var fetchedDay: Days?
        var fetchedMonth: Days?
        
        guard DataManager.shared.token != nil else {
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
                print("success")
            default:
                break
            }
            group.leave()
        }
        if fetchedDay != nil {
            group.enter()
            DataManager.shared.fetchMonthData { result in
                switch result {
                case .success(let month):
                    fetchedMonth = month
                default:
                    break
                }
                group.leave()
            }
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


struct DataView: View {
    let dayData: Days?
    let monthData: Days?
    
    
    var dayTime: Int = 0
    var monthTime: Int = 0
    
    var body: some View {
        
        makeText()
    }
    
    private func getAllTime() -> [Int] {
        guard let day = self.dayData, let month = self.monthData else {
//            print("error")
            return [0, 0]
        }
        var dayTime = 0
        for log in day.inOutLogs {
            dayTime += log.durationSecond
        }
        
        var monthTime = 0
        for log in month.inOutLogs {
            monthTime += log.durationSecond
        }
        return [monthTime, dayTime]
    }
    private func makeText() -> some View {
        let times = self.getAllTime()
        var dayText = ""
        var monthText = ""
        
        if times[0] == 0 {
            dayText = "0 : 0 : 0"
        } else {
            dayText = "\(times[1] / 3600) : \(times[1] % 3600 / 60) : \(times[1] % 3600 % 60)"
        }
        
        if times[1] == 0 {
            monthText = "0 : 0 : 0"
        } else {
            monthText = "\(times[0] / 3600) : \(times[0] % 3600 / 60) : \(times[0] % 3600 % 60)"
        }
        
        return VStack(spacing: 5) {
            Text(dayText)
            Text(monthText)
        }
    }
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry
    
    @State var myData: Days?
    @State var text = "hello sma"
    
    var body: some View {
        if entry.hasToken {
            DataView(dayData: entry.day, monthData: entry.month)
        } else {
            Text("no token")
        }
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetEntryView(entry: SimpleEntry(date: Date(), day: nil, month: nil, hasToken: true))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//}
//
//struct widgetEntryView : View {
//    @Environment(\.widgetFamily) var widgetFamily
//    
//    var entry: Provider.Entry
//    
//    var body: some View {
//        switch widgetFamily{
//        case .accessoryCircular:
//            CircularWidgetView()
//        default:
//            Text("hello")
//        }
//    }
//}
//
//struct CircularWidgetView: View {
//    
//    @State var percentage: Double = 0.2
//    
//    var body: some View {
//        ZStack {
//            RingView(percentage: percentage)
//                .rotationEffect(Angle(degrees: 150))
//            DefaultTextView()
//        }
//    }
//}
//
//struct TrackRunWidgetEntryView : View {
//    var entry: Provider.Entry
//    @Environment(\.widgetFamily) var widgetFamily
//    
//    @State var percentage: Double = 0.5
//    
//    var body: some View {
//        switch widgetFamily {
//        case .accessoryCircular:
//            TrackRunView(percentage: percentage)
//        default:
//            Text("hello world")
//        }
//    }
//}
//
//struct TrackRunWidget: Widget {
//    let kind: String = "TrackRunWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            TrackRunWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My TrackRunWidget")
//        .description("This is an example widget.")
//        .supportedFamilies([.accessoryCircular])
//    }
//}
//
//struct TimeScaleWidgetEntryView : View {
//    var entry: Provider.Entry
//    @Environment(\.widgetFamily) var widgetFamily
//    
//    @State var percentage: Double = 0.2
//    
//    var body: some View {
//        switch widgetFamily {
//        case .accessoryCircular:
//            TimeScaleView(percentage: percentage)
//        default:
//            Text("hello world")
//        }
//    }
//}
//
//
//
////@main
//struct TimeScaleWidget: Widget {
//    let kind: String = "TimeScaleWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            TimeScaleWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My TimeScaleWidget")
//        .description("This is an example widget.")
//        .supportedFamilies([.accessoryCircular])
//    }
//}
//
////@main
//struct widget: Widget {
//    let kind: String = "widget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            widgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//        .supportedFamilies([.accessoryCircular])
//    }
//}
//
//@main
//struct MyWidget: WidgetBundle {
//    var body: some Widget {
//        // ...(다른 위젯들)
//        TimeScaleWidget()
//        widget()
//        TrackRunWidget()
//    }
//}
//
//
//struct widget_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            TimeScaleWidgetEntryView(entry: SimpleEntry(date: Date()))
//                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
//            widgetEntryView(entry: SimpleEntry(date: Date()))
//                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
//            TrackRunWidgetEntryView(entry: SimpleEntry(date: Date()))
//                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
//        }
//    }
//}
