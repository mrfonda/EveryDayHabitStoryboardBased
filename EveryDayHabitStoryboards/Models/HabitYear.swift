//
//  HabitYear.swift
//  EveryDayHabitStoryboards
//
//  Created by Vladislav Dorfman on 14/11/2020.
//

import Foundation

class HabitYear {
    var year: Int
    var months: [HabitMonth]
    
    init?(year: Int) {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, year: year)
        
        guard let date = calendar.date(from: components),
              let rangeMonth = calendar.range(of: .month, in: .year, for: date) else { return nil }
        self.year = year

        months = rangeMonth.compactMap{ month -> HabitMonth? in
            return HabitMonth(calendar: calendar, year: year, month: month)
        }
    }
    
}

class HabitMonth {
    let year: Int
    let month: Int
    let name: String
    let days: [HabitDay]
    
    init?(calendar: Calendar, year: Int, month: Int) {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, year: year, month: month)
        
        guard let date = calendar.date(from: components),
              let rangeDays = calendar.range(of: .day, in: .month, for: date) else { return nil }
        self.year = year
        self.month = month
    
        name = calendar.monthSymbols[month-1]
        
        days = rangeDays.compactMap{ (day) -> HabitDay? in
            return HabitDay(day: day)
        }
    }
}

class HabitDay {
    let num: Int
    var isHabitTrained: Bool = false
    init(day: Int) {
        self.num = day
    }
}
