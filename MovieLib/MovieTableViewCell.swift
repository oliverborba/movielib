//
//  MovieTableViewCell.swift
//  MovieLib
//
//  Created by Lucas Oliveira de Borba on 26/07/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSummary: UILabel!
    @IBOutlet weak var labelRating: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWith(_ movie: Movie){
        labelTitle.text = movie.title
        labelRating.text = "⭐️ \(movie.rating)"
        labelSummary.text = movie.summary
        if let image = movie.image{
        imageViewPoster.image = UIImage(data: image)
    }}
}
