//
//  MenuViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/6.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import IBAnimatable
import RxSwift
import RxCocoa
import RxDataSources
import EZSwiftExtensions

class MenuViewController: AnimatableViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<MenuSection> = {
        return RxTableViewSectionedReloadDataSource<MenuSection>()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 213
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let sections: [MenuSection] = [
            .TitleSection(items: [
                .TitleSectionItem(title: "设置", click: { [unowned self] in
                    guard let vc = R.storyboard.setting.settingNavgationController() else { fatalError("settingViewController is nil") }
                    self.presentVC(vc)
                }),
                .TitleSectionItem(title: "开源许可", click: { [unowned self] in
                    guard let vc = R.storyboard.license.licenseNavgationController() else { fatalError("settingViewController is nil") }
                    self.presentVC(vc)
                }),
                .TitleSectionItem(title: "意见反馈", click: { print("意见反馈") })
                ])
        ]
        
        dataSource.configureCell = { dataSource, table, idxPath, _ in
            
            switch dataSource[idxPath] {
            case let .TitleSectionItem(title, _):
                let cell: MenuTableViewCell = table.dequeueReusableCell(forIndexPath: idxPath)
                cell.titleLab.text = title
                return cell

            }
            
        }
        
        Observable.just(sections)
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch dataSource[indexPath] {
        case let .TitleSectionItem(_, click):
            click()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MenuTableViewCell else {
            return
        }
        
        cell.cellView.animationType = .slideFade(way: .in, direction: .right)
        cell.cellView.delay = 0.6 + Double(indexPath.row) * 0.2
        cell.cellView.autoRunAnimation()
    }
    
}
