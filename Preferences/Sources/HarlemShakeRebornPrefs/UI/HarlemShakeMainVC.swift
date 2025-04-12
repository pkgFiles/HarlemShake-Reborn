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
import HarlemShakeRebornPrefsC

class HarlemShakeMainVC: PSListController {

    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 325))
    
    override init(forContentSize contentSize: CGSize) {
        super.init(forContentSize: contentSize)
        
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath.circle.fill"), style: .plain, target: self, action: #selector(respringDevice))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Respring", style: .plain, target: self, action: #selector(respringDevice))
        }
        
        let bannerImageView = UIImageView(frame: headerView.bounds)
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.image = UIImage(contentsOfFile: prefsAssetsPath + "HSBanner.png")
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(bannerImageView)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: -50),
            bannerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
        
        self.view.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NavigationBarManager.setNavBarThemed(enabled: true, vc: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NavigationBarManager.setNavBarThemed(enabled: false, vc: self)
    }
    
    //MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
 
    //MARK: - Actions
    @objc func respringDevice() {
        respring()
    }
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableHeaderView = headerView
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    //MARK: - Required
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
