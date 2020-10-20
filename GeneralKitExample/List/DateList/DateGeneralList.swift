//
//  DateGeneralList.swift
//  Jobs
//
//  Created by Salah on 3/15/19.
//  Copyright © 2019 Salah. All rights reserved.
//

import Foundation
import DateToolsSwift
import DateTools
// for tableViewCell && collectionviewCell
import SwifterSwift
protocol DateGeneralCellProtocol:MultiSelectGeneralCellProtocol{
    func currentDateStyle();
}
protocol DateGeneralViewProtocol:MultiSelectGeneralViewProtocol {
    var currentDate:Date { set get}
    var startDate:Date? { set get}
    var endDate:Date? { set get}

}
protocol DateConnection:MultiSelectGeneralViewProtocol{

}
class DateTableViewCell:GeneralMultiSelectTableViewCell,DateGeneralCellProtocol {
    override func selectedStyle() {
        
    }
    
    override func deSelectedStyle() {
        
    }
    func currentDateStyle(){
        
    }
}

extension DateGeneralViewProtocol where Self: DateConnection {
    @discardableResult  func startDate(_ startDate:Date)->Self{
        self.startDate=startDate;
        return self
    }
    @discardableResult func endDate(_ endDate:Date)->Self{
        self.endDate = endDate
        return self;
    }
    @discardableResult func after(year:Int)->Self{
        var currnetDate = Date()
        currnetDate.year(Date.init().component(.year) + year);
        self.endDate(currnetDate);
        return self
    }

    @discardableResult func before(year:Int)->Self{
        var currnetDate = Date.init()
        currnetDate.year(( Date.init().component(.year) - year ));
        self.startDate(currnetDate);
        return self
    }
    func executeDateSetting(){
        var dates:[GeneralCellData] = [GeneralCellData]();
        // Formatter for printing the date, adjust it according to your needs:
        var newDate:Date = self.startDate!;
        while newDate <= self.endDate! {
            newDate = Calendar.current.date(byAdding: .day, value: 1, to: newDate)!
            dates.append(self.converterHandler?(newDate) ?? GeneralCellData.init(identifier: self.identifier!, object: newDate));
        }
        self.objects.value = dates;
    }
}
