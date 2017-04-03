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
    
    var query: NSMetadataQuery = NSMetadataQuery()
    
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SettingSection> = {
       return RxTableViewSectionedReloadDataSource<SettingSection>()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        let sections: [SettingSection] = [
            .SwitchSection(items: [
                .SwitchItem(title: "启动TouchID", isOn: UserDefaults.Setting.bool(forKey: .enableTouchID), setValue: { UserDefaults.Setting.set($0, forKey: .enableTouchID) })
                ])
        ]
        
        dataSource.configureCell = { dataSource, tableView, idxPath, _ in
            
            switch dataSource[idxPath] {
            case let .SwitchItem(title, isOn, setValue):
                let cell: SettingSwitchTableViewCell = tableView.dequeueReusableCell(forIndexPath: idxPath)
                cell.titleLab.text = title
                cell.switchBtn.isOn = isOn
                cell.switchBtn.rx.isOn.bindNext(setValue)
                    .addDisposableTo(cell.rx.prepareForReuseBag)
                return cell
            case let .TitleItem(title, _):
                let cell: SettingTitleTableViewCell = tableView.dequeueReusableCell(forIndexPath: idxPath)
                cell.titleLab.text = title
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

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch dataSource[indexPath] {
        case let .TitleItem(_, click):
            click()
            tableView.deselectRow(at: indexPath, animated: false)
            
        default:
            break
            
        }
        
    }
    
    
}

extension SettingViewController: SyncFileToiCloud {
    
    var fileName: String {
        return Constant.realmFileName
    }
    
    var ubiquitContainerIdentifier: String {
        return Constant.iCloudContainerId
    }
    
}
