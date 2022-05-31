//
//  GDListViewController.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 26/05/22.
//

import UIKit

class GDListViewController: GDBaseViewController {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    private var tableViewHandler: GDTableViewHandler
    
    init(loader:GDLoader, tableViewHandler: GDTableViewHandler) {
        self.tableViewHandler = tableViewHandler
        super.init(loader: loader, nibName: "GDListViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTableView.register(
            UINib(nibName: "GDPoiTableViewCell", bundle: nil),
            forCellReuseIdentifier: GDPoiTableViewCell.reuseIdentifier
        )
        // load character list
        self.loadingView.isHidden = false
        self.loader.delegate = self
        self.loader.load(urlString: GDConst.defaultVehicleListURLString, handler: GDOperationQueueManager.instance)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loader.delegate = self
        self.mainTableView.reloadData()
        // Make handler to load address at first loading
        self.tableViewHandler.tableViewDidEndDecelerating(self.mainTableView)
    }
}

//MARK: UITableViewDataSource
extension GDListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewHandler.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableViewHandler.tableView(tableView, cellForRowAt: indexPath)
    }
}

//MARK: UIScrollViewDelegate
extension GDListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.tableViewHandler.tableViewDidEndDecelerating(self.mainTableView)
    }
}

//MARK: UITableViewDelegate
extension GDListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableViewHandler.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
}

//MARK: GDLoaderDelegate
extension GDListViewController: GDLoaderDelegate {
    func loaderDidStart(_ loader: GDLoader) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
        }
    }
    
    func loaderDidLoad(_ loader: GDLoader, data: [Data]?) {
        if let d = data?[0] {
            self.tableViewHandler.listFromData(d)
        }
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.mainTableView.dataSource = self
            self.mainTableView.delegate = self
            self.mainTableView.reloadData()
            // Make handler to load address at first loading
            self.tableViewHandler.tableViewDidEndDecelerating(self.mainTableView)
        }
    }
    
    func loaderFailed(_ loader: GDLoader, error: Error) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.showError(error)
        }
    }
    
    func loaderCancelled(_ loader: GDLoader) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
    }
}
