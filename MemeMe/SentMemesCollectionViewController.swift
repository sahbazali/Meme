//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Ali Şahbaz on 1.01.2021.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    let sentMemes = Meme.sentMemes
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.collectionView.reloadData()
    }
    
    @IBAction func createMemeClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "MemeViewController") as! MemeViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func setupCollectionLayout(){
        let space : CGFloat = 3.0
        let width = (view.frame.width - (2 * space)) / 3.0
        let height = (view.frame.height - (2 * space)) / 3.0
        collectionLayout.minimumInteritemSpacing = space
        collectionLayout.minimumLineSpacing = space
        collectionLayout.itemSize = CGSize(width: width, height: height)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.sentMemes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemesCollectionViewCell
        cell.sentMemeImage?.image = Meme.sentMemes[indexPath.item].memedImage    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        vc.sentMeme = Meme.sentMemes[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SentMemesCollectionViewController : MemeViewConrollerDelegate {
    func memeViewControllerDidDismissed() {
        self.collectionView.reloadData()
    }
}
