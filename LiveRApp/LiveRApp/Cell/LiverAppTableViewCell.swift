//
//  LiverAppTableViewCell.swift
//  LiveRApp
//
//  Created by Menti on 18/12/24.
//

import UIKit
import SDWebImage

class LiverAppTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(comment: Comments?){
        self.lblUserName.text = comment?.username ?? ""
        self.lblComments.text = comment?.comment ?? ""
        self.imgView.sd_setImage(with: URL(string: comment?.picURL ?? ""), placeholderImage: UIImage(named: "commentProfPic"), context: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
