
class FileManagerStore {
    
    let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    private func documentPath() -> URL? {
        guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentPath
    }
    
    private func downloadImage(imageStr: String, completion: @escaping(UIImage?) -> () ) {
        
        if let url = URL(string: imageStr) {
            
            DispatchQueue.global(qos: .background).async {
                
                guard let loadData = try? Data(contentsOf: url) else { return }
                
                DispatchQueue.main.async {
                    if let loadedImage = UIImage(data: loadData) {
                        completion(loadedImage)
                        print("donwload image")
                    }
                }
            }
        }
    }
    
    func saveImage(imageStr: String, name: String) {
        
        downloadImage(imageStr: imageStr) { image in
            
            if let dataImage = image?.pngData() {
                
                do {
                    guard let filePath = self.documentPath()?.appendingPathComponent(self.createFileName(fileName: name)) else { return }
                    
                    try dataImage.write(to: filePath)
                    
                    print("\(self.createFileName(fileName: name)) was saved to file mananager")
                    
                } catch {
                    print("Error")
                }
            } else {
                print("could not converted to pngData")
            }
        }
        
    }
    
    func fetchImage(imageName: String) -> UIImage? {
        
        guard let imagePath = documentPath()?.appendingPathComponent(imageName).path else { return nil }
        
        guard fileManager.fileExists(atPath: imagePath) else {
            print("\(imagePath) not founded")
            return nil
        }
        
        if let image = UIImage(contentsOfFile: imagePath) {
            print("fetch image")
            return image
        } else {
            print("images not created \(imagePath)")
            return nil
        }
            
    }
    
    func createFileName(fileName name: String) -> String {
        return name.replacingOccurrences(of: "/", with: "") + ".png"
    }
}
