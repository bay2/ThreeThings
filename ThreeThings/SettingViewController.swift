//
//  SettingViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/7.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class SettingViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    lazy var dataSource: RxTableViewSectionedReloadDataSource<SettingSection> = {
       return RxTableViewSectionedReloadDataSource<SettingSection>()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let sections: [SettingSection] = [
            .SwitchSection(items: [
                .SwitchItem(title: "启动TouchID", isOn: UserDefaults.Setting.bool(forKey: .enableTouchID), setValue: { UserDefaults.Setting.set($0, forKey: .enableTouchID) })
                ])
        ]
        
        dataSource.configureCell = { dataSource, tableView, idxPath, _ in
            
            switch dataSource[idxPath] {
            case let .SwitchItem(title, isOn, setValue):
                let cell: SettingTableViewCell = tableView.dequeueReusableCell(forIndexPath: idxPath)
                cell.titleLab.text = title
                cell.switchBtn.isOn = isOn
                cell.switchBtn.rx.isOn.bindNext(setValue)
                    .addDisposableTo(cell.rx.prepareForReuseBag)
                return cell
            }            
        }
        
        Observable.just(sections)
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
            
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
