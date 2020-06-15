//
//  DetailedMemeViewController.swift
//  MemeMe1.0
//
//  Created by Riham Mastour on 22/10/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit

class DetailedMemeViewController: UIViewController {

    //MARK: OUTLETS
    
    @IBOutlet weak var detailedMeme: UIImageView!
    var meme : Meme!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailedMeme.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
