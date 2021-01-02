//
//  SentMemeDetailViewController.swift
//  MemeMe
//
//  Created by Ali Şahbaz on 1.01.2021.
//

import UIKit

class SentMemeDetailViewController: UIViewController {

    var sentMeme : Meme!
    @IBOutlet weak var sentMemeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentMemeImage.image = sentMeme.memedImage
    }
}
