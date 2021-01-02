//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ali Şahbaz on 1.01.2021.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    let sentMemes = Meme.sentMemes
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.reloadData()
    }

    @IBAction func createMemeClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "MemeViewController") as! MemeViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Meme.sentMemes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath)

        cell.imageView?.image = Meme.sentMemes[indexPath.row].memedImage
        cell.textLabel?.text = Meme.sentMemes[indexPath.row].topText + "  " + Meme.sentMemes[indexPath.row].bottomText
        cell.textLabel?.lineBreakMode = .byTruncatingMiddle

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        vc.sentMeme = Meme.sentMemes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SentMemesTableViewController : MemeViewConrollerDelegate {
    func memeViewControllerDidDismissed() {
        self.tableView.reloadData()
    }
}
