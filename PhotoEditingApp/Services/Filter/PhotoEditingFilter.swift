enum PhotoEditingFilter: String, CaseIterable {
    case cross = "CIColorCrossPolynomial"
    case cube = "CIColorCube"
    case cubeSpace = "CIColorCubeWithColorSpace"
    case invert = "CIColorInvert"
    case map = "CIColorMap"
    case monochrome = "CIColorMonochrome"
    case posterize = "CIColorPosterize"
    case falsecolor = "CIFalseColor"
    case maskalpha = "CIMaskToAlpha"
    case maxComponent = "CIMaximumComponent"
    case minComponent = "CIMinimumComponent"
    case photochrome = "CIPhotoEffectChrome"
    case photofade = "CIPhotoEffectFade"
    case photoinstant = "CIPhotoEffectInstant"
    case photomono = "CIPhotoEffectMono"
    case photonoir = "CIPhotoEffectNoir"
    case photoprocess = "CIPhotoEffectProcess"
    case phototonal = "CIPhotoEffectTonal"
    case phototransfer = "CIPhotoEffectTransfer"
    case sepia = "CISepiaTone"
    case vignette = "CIVignette"
    case vignetteeffect = "CIVignetteEffect"
}
