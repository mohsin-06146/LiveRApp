//
//  ViewController.swift
//  LiveRApp
//
//  Created by Menti on 18/12/24.
//

import UIKit
import AVKit
import AVFoundation

class StreamPlayBackVC: UIViewController {
    //MARK: - Variables
    var videos: [Videos]?
    var comments: [Comments]?
    var player: AVPlayer?
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let viewModel = StreamPlayBackViewModel()
        videos = viewModel.loadVideos()
        comments = viewModel.loadComments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.collectionView.register(UINib(nibName: "LiverAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiverAppCollectionViewCell")
        self.collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource Methods
extension StreamPlayBackVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiverAppCollectionViewCell", for: indexPath) as? LiverAppCollectionViewCell
        cell?.comments = self.comments
        cell?.setData(cellVideo: self.videos?[indexPath.row])
        let videoUrl = URL(string: self.videos?[indexPath.row].video ?? "")
        self.player?.pause()
        self.player = nil
        self.player = AVPlayer(url: videoUrl!)
        cell?.setupAVPlayer(player: player)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        return size
    }
}

