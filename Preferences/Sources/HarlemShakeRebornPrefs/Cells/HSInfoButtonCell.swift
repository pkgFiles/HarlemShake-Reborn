/*
 
 MIT License
 
 Copyright (c) 2025 ★ Install Package Files
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import Preferences
import AudioToolbox.AudioServices

@available(iOS 13.0, *)
class HSInfoButtonCell: PSTableCell {

    //MARK: - Propertys
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonDetails: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = tweakColor
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showDetailsAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String, specifier: PSSpecifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buttonLabel.text = specifier.property(forKey: "buttonLabelText") as? String
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(buttonLabel)
        self.contentView.addSubview(buttonDetails)
        
        NSLayoutConstraint.activate([
            buttonLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            buttonLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),

            buttonDetails.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            buttonDetails.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -22.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    @objc func showDetailsAlert() {
        guard let viewController = self.findViewController() else { return }
        AudioServicesPlayAlertSound(1521)
        
        let alertController = UIAlertController(title: buttonLabel.text, message: specifier.property(forKey: "buttonInfoText") as? String, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(dismissAction)
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true)
        }
    }
}
