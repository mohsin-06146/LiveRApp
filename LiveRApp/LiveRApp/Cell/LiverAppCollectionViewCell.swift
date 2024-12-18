//
//  LiverAppCollectionViewCell.swift
//  LiveRApp
//
//  Created by Menti on 18/12/24.
//

import UIKit
import AVKit
import AVFoundation

class LiverAppCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    //MARK: - Variables
    var comments: [Comments]?
    var cellPlayer: AVPlayer?
    var isPlayerPlay = false
    var video: Videos?
    
    //MARK: - Outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblViewersCount: UILabel!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLikesCount: UILabel!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var imgViewProfileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tblView.register(UINib(nibName: "LiverAppTableViewCell", bundle: nil), forCellReuseIdentifier: "LiverAppTableViewCell")
        self.tblView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchAction(_:)))
        self.bgView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            self.cellPlayer?.seek(to: CMTime.zero)
            self.cellPlayer?.play()
        }
        
        self.scrollToBottom()
    }
    
    @objc func touchAction(_ sender:UITapGestureRecognizer){
        if self.isPlayerPlay{
            cellPlayer?.pause()
        }else{
            cellPlayer?.play()
        }
        self.isPlayerPlay.toggle()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource Methods
extension LiverAppCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiverAppTableViewCell", for: indexPath) as? LiverAppTableViewCell
        cell?.setData(comment: comments?[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let cellCount = self.tblView.visibleCells.count
        let alphaInterval:CGFloat = 1.0 / CGFloat(cellCount / 2)

        for (index,cell) in (self.tblView.visibleCells as [UITableViewCell]).enumerated() {

            if index == cellCount - 1{
                cell.alpha = 1.0
            }else{
                cell.alpha = CGFloat(index) * alphaInterval
            }
        }
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
            self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate Methods
extension LiverAppCollectionViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtComment.resignFirstResponder()
        let comment = textField.text ?? ""
        textField.text = ""
        if !comment.isEmpty{
            let objComment = Comments(id: 0, username: video?.username ?? "", picURL: video?.profilePicURL ?? "", comment: comment)
            self.comments?.append(objComment)
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.scrollToBottom()
            }
        }
        return true
    }
}

//MARK: - UseFul Methods
extension LiverAppCollectionViewCell{
    func setupAVPlayer(player: AVPlayer?){
        self.cellPlayer = player
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let playerLayer = AVPlayerLayer(player: self.cellPlayer)
            playerLayer.frame = self.backgroundImage.frame
            playerLayer.videoGravity = .resizeAspectFill
            self.backgroundImage.layer.addSublayer(playerLayer)
            self.makeGradientImageView()
            self.cellPlayer?.play()
            self.isPlayerPlay = true
        }
    }
    
    func setData(cellVideo: Videos?){
        self.video = cellVideo
        self.lblViewersCount.text = "\(self.video?.viewers ?? 0)"
        self.lblLikesCount.text = "\(self.video?.likes ?? 0)"
        self.lblTopic.text = self.video?.topic ?? ""
        self.lblUserName.text = self.video?.username ?? ""
        self.imgViewProfileImage.sd_setImage(with: URL(string: self.video?.profilePicURL ?? ""), placeholderImage: UIImage(named: "commentProfPic"), context: nil)
        self.txtComment.attributedPlaceholder = NSAttributedString(
            string: "Comment",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }

    func makeGradientImageView(){
        let view = UIView(frame: backgroundImage.frame)

        let gradient = CAGradientLayer()

        gradient.frame = view.frame

        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.4).cgColor]

        gradient.locations = [0.0, 1.0]

        view.layer.insertSublayer(gradient, at: 0)

        backgroundImage.addSubview(view)
        backgroundImage.bringSubviewToFront(view)
    }
}
