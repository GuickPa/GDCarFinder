//
//  GDTabBarController.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 29/05/22.
//

import UIKit

class GDTabBarController: UITabBarController {
    
    let loader: GDLoader = GDDataLoader()
    let listHandler: GDListHandler = GDCarListHandler(decoder: GDGenericDataDecoder())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        self.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        }
        self.setupTabs()
    }
    
    private func setupTabs() {
        self.viewControllers = [setupListTab(), setupMapTab()]
        self.tabBar.items?.indices.forEach{
            let item = self.tabBar.items![$0]
            item.image = UIImage(systemName: "person")
            item.selectedImage = UIImage(systemName: "person.fill")
        }
    }
    
    private func setupListTab() -> UIViewController{
        let vc = GDListViewController(
            loader: self.loader,
            tableViewHandler: GDCarTableViewHandler(
                listHandler: self.listHandler,
                cellHandler: GDPoiTableViewCellHandler())
            )
        vc.title = GDConst.localizedString("gd_tab_list_title")
        return vc
    }
    
    private func setupMapTab() -> UIViewController{
        let vc = GDMapViewController(
            loader: self.loader,
            mapHandler: GDMapViewHandler(listHandler: self.listHandler)
        )
        vc.title = GDConst.localizedString("gd_tab_map_title")
        return vc
    }
}
