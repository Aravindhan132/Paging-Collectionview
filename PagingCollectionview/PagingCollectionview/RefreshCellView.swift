//
//  RefreshCellView.swift
//  PagingCollectionview
//
//  Created by aravind-pt2199 on 28/08/18.
//  Copyright © 2018 aravind-pt2199. All rights reserved.
//

import UIKit

class RefreshCellView: UITableViewCell {

    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startStopLoading(_ isStart : Bool)
    {
        if(isStart)
        {
            progressView.startAnimating()
            progressLabel.text = "Fetching Data"
        }
        else
        {
            progressView.stopAnimating()
            progressLabel.text = "Pull for more data"
        }
    }

}
