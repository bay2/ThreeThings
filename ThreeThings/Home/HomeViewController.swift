//
//  HomeViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/17.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import FSCalendar
import EZSwiftExtensions
import IBAnimatable

typealias ThingSectionModel = AnimatableSectionModel<String, ThingItem>
class HomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet var scopeGesture: UIPanGestureRecognizer!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let dataSource = RxTableViewSectionedAnimatedDataSource<ThingSectionModel>()
    
    fileprivate let homeStore = HomeStore()
    
    fileprivate var dateList: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, element in
            let cell: HomeThingTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.infoLab.text = element.thing
            return cell
        }
        
        tableView.estimatedRowHeight = 213
        tableView.rowHeight = UITableViewAutomaticDimension
                
        homeStore.getter.thingsList
            .map { [ThingSectionModel(model: "thing", items: $0)] }
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        homeStore.getter.thingsDateList.bindNext { [unowned self] dateList in
            self.dateList = dateList
            }
            .addDisposableTo(disposeBag)
        
        scopeGesture.addTarget(self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        view.addGestureRecognizer(self.scopeGesture)
        tableView.panGestureRecognizer.require(toFail: scopeGesture)
        
        calendar.dataSource = self
        calendar.delegate = self
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK:- UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = tableView.contentOffset.y <= -tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        Observable.just(date)
            .flatMap(homeStore.dispatch.fetch)
            .bindNext {
            }
            .addDisposableTo(disposeBag)
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        return dateList.filter { $0 == date }.count
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [R.color.home.silverTree()]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [R.color.home.silverTree()]
    }

}



