//
//  GameBoardViewController.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/14/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
    
    @IBOutlet weak var tempView: UIView!
    
    var deckArray: [String]?
    var difficulty: Int?
    var timer = Timer()
    var countDownLbl = UILabel()
    var counter = 0
    
    var countDown = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if (self.isMovingFromParentViewController) {
//            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
//        }
//    }
    
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscape
//    }
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .landscapeLeft
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(deckArray!)
        print(difficulty!)
        
        createTempTimerLbl()
        startCountDown()
        
//        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    
    func createTempTimerLbl() {
        countDownLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        countDownLbl.center = CGPoint(x: view.center.x, y: view.center.y)
        countDownLbl.font = UIFont(name: "Helvetica", size: 100.0)
        countDownLbl.textAlignment = .center
        countDownLbl.text = "\(countDown)"
        self.view.addSubview(countDownLbl)
    }
    
    func startCountDown() {
        // Start the count down for the intro count.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameBoardViewController.updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        
        // This is the actual count down and manipulation of the label.
        if countDown > 1 {
            // Have the count down by 1 interval.
            countDown -= 1
            countDownLbl.text = String(countDown)
        } else if countDown == 1 {
            countDownLbl.isHidden = true
            countDown -= 1
            tempView.isHidden = false
        } else if countDown == 0 {
            timer.invalidate()
            countDown = 3
            countDownLbl.text = String(countDown)
            countDownLbl.isHidden = true
            tempView.isHidden = true
            tempTimer()
        }
    }
    
    func tempTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(GameBoardViewController.updateTempCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateTempCounter() {
        counter += 1
       print(counter)
        if counter == 4 {
            let scoreViewController = storyboard?.instantiateViewController(withIdentifier: "scoreViewController") as! ScoreBoardViewController
            present(scoreViewController, animated: true, completion: nil)
            
            timer.invalidate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Hide the status bar programatically.
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
