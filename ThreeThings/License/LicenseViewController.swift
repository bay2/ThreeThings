//
//  LicenseViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/10.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class LicenseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var datasource: RxTableViewSectionedReloadDataSource<LicenseSection> = {
        return RxTableViewSectionedReloadDataSource<LicenseSection>()
    }()
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let sections: [LicenseSection] = [.LicenseSection(items: [.LicenseItem(frameworks: .EZSwiftExtensions),
                                                                  .LicenseItem(frameworks: .MonkeyKing),
                                                                  .LicenseItem(frameworks: .ReX),
                                                                  .LicenseItem(frameworks: .Rswift),
                                                                  .LicenseItem(frameworks: .RxSwift),
                                                                  .LicenseItem(frameworks: .RxDataSources),
                                                                  .LicenseItem(frameworks: .RxKeyboard),
                                                                  .LicenseItem(frameworks: .Realm),
                                                                  .LicenseItem(frameworks: .FSCalendar),
                                                                  .LicenseItem(frameworks: .IBAnimatable)])]
        
        
        datasource.configureCell = { datasource, tableView, idxPath, _ in
            let cell: LicenseTableViewCell = tableView.dequeueReusableCell(forIndexPath: idxPath)
            
            if case .LicenseItem(frameworks: let frameworks) = datasource[idxPath] {
                cell.textLabel?.text = frameworks.frameworkName
            }
            
            return cell
  
        }
        

        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        Observable.just(sections)
            .bindTo(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        

    }

    @IBAction func back(_ sender: Any) {
        popVC();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension LicenseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch datasource[indexPath] {
        case .LicenseItem(frameworks: let frameworks):
            
            guard let vc = R.storyboard.license.licenseWebViewController() else {
                fatalError("licenseWebViewController is nil")
            }
            
            vc.licenseUrl = frameworks.licenseURL
            vc.title = frameworks.frameworkName
            
            self.pushVC(vc)
            tableView.deselectRow(at: indexPath, animated: true)

        }
        
    }

    
}
