import UIKit

extension PhotoEditingView {

    func showAdjusts() {
        DispatchQueue.main.async {
            self.adjustsStackView.fadeIn()
            if self.brightnessButton.isSelected {
                self.brightnessSlider.fadeIn()
            } else {
                if self.contrastButton.isSelected {
                    self.contrastSlider.fadeIn()
                } else {
                    if self.saturationButton.isSelected {
                        self.saturationSlider.fadeIn()
                    }
                }
            }
        }
    }
    
    func showFilters() {
        DispatchQueue.main.async {
            self.adjustsStackView.fadeOut()
            self.brightnessSlider.fadeOut()
            self.contrastSlider.fadeOut()
            self.saturationSlider.fadeOut()
        }
    }

    @objc func adjustSelected(_ sender: UIButton) {
        assert(Thread.isMainThread, "Should run on main thread")
        switch sender {
        case brightnessButton:
            UIView.animate(withDuration: 0.3) {
                self.brightnessButton.isSelected = true
                self.saturationButton.isSelected = false
                self.contrastButton.isSelected = false
                self.contrastSlider.isHidden = true
                self.saturationSlider.isHidden = true
            }
            self.brightnessSlider.fadeIn {
                self.layoutIfNeeded()
            }
        case contrastButton:
            UIView.animate(withDuration: 0.3) {
                self.brightnessButton.isSelected = false
                self.saturationButton.isSelected = false
                self.contrastButton.isSelected = true
                self.brightnessSlider.isHidden = true
                self.saturationSlider.isHidden = true
            }
            self.contrastSlider.fadeIn {
                self.layoutIfNeeded()
            }
        case saturationButton:
            UIView.animate(withDuration: 0.3) {
                self.brightnessButton.isSelected = false
                self.saturationButton.isSelected = true
                self.contrastButton.isSelected = false
                self.brightnessSlider.isHidden = true
                self.contrastSlider.isHidden = true
            }
            self.saturationSlider.fadeIn {
                self.layoutIfNeeded()
            }
        default:
            assertionFailure("This target should not be called by a not registered button")
            break
        }
    }

    @objc func sliderValueDidChange(_ sender: UISlider) {
        if saveButton.isHidden { saveButton.fadeIn() }
        switch sender {
        case brightnessSlider:
            guard let originalFilter = originalFilter else {
                assertionFailure("Original filter should not be nil")
                return
            }
            assert(Thread.isMainThread, "Should run on main thread")
            originalFilter.setValue(sender.value, forKey: kCIInputBrightnessKey)
            if let ciimage = originalFilter.outputImage {
                photoImageView.image = ciimage
            }
        case contrastSlider:
            guard let originalFilter = originalFilter else {
                assertionFailure("Original filter should not be nil")
                return
            }
            assert(Thread.isMainThread, "Should run on main thread")
            originalFilter.setValue(sender.value, forKey: kCIInputContrastKey)
            if let ciimage = originalFilter.outputImage {
                photoImageView.image = ciimage
            }
        case saturationSlider:
            guard let originalFilter = originalFilter else {
                assertionFailure("Original filter should not be nil")
                return
            }
            assert(Thread.isMainThread, "Should run on main thread")
            originalFilter.setValue(sender.value, forKey: kCIInputSaturationKey)
            if let ciimage = originalFilter.outputImage {
                photoImageView.image = ciimage
            }
        default:
            assertionFailure("This target should not be called by a not registered button")
            break
        }
    }
}
