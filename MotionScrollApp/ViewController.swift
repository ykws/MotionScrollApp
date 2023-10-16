//
//  ViewController.swift
//  MotionScrollApp
//
//  Created by KAWASHIMA Yoshiyuki on 2023/10/15.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var controllButton: UIButton!
     
    // MARK: - IBActions
    
    @IBAction func touchDown(_ sender: Any) {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self,
                  let data = data else { return }
            
            if (baseAccelerationY == nil) {
                baseAccelerationY = data.acceleration.y
            }
            
            let calcuratedOffsetY = (baseAccelerationY! - data.acceleration.y) * 300
            tableViewOffsetY += calcuratedOffsetY
            let maxY = tableView.contentSize.height - tableView.bounds.height + view.safeAreaInsets.bottom
            if (tableViewOffsetY < 0) { tableViewOffsetY = 0 }
            if (maxY < tableViewOffsetY) { tableViewOffsetY = maxY }
            tableView.setContentOffset(CGPoint(x: 0, y: tableViewOffsetY), animated: true)
        }
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        motionManager.stopAccelerometerUpdates()
        baseAccelerationY = nil
    }
    
    @IBAction func touchUpOutside(_ sender: Any) {
        motionManager.stopAccelerometerUpdates()
        baseAccelerationY = nil
    }
    
    // MARK: - Properties
    
    let motionManager = CMMotionManager()
    var baseAccelerationY: CGFloat? = nil
    var tableViewOffsetY: CGFloat = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }
    
    deinit {
        motionManager.stopAccelerometerUpdates()
    }
}
    
// MARK: - TableView DataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }
}

