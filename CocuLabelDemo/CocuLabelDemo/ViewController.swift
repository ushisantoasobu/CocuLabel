import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet weak var label: CocuLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.btnNextTapped(UIButton())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnNextTapped(sender: AnyObject) {
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
        
        //use https://unsplash.it/ this is great a service, THX!
        var url = NSURL(string: "https://unsplash.it/640/1132/?random")
        iv.sd_setImageWithURL(url!,
            placeholderImage: nil,
            options: SDWebImageOptions.RefreshCached,
            completed: { (img, err, type, url) -> Void in
                if type != SDImageCacheType.None {
                    return
                }
                if img != nil {
                    self.label.updateColor()
                }
                SVProgressHUD.dismiss()
            }
        )
    }
    
}

