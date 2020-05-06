
protocol FileManagerPath {
    var fileManager: FileManager { get }
}

extension FileManagerPath {
    
    var fileManager: FileManager {
        return FileManager.default
    }
    
    var documentsPath: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

// MARK: - Retrieves images from the documents library for the specified name

struct FileStore: FileManagerPath {
    func fetchImage(by name: String) -> UIImage? {
        let imagePath = documentsPath.appendingPathComponent(name).path
        return UIImage(contentsOfFile: imagePath)
    }
}

// MARK: - The upload images at the specified path

protocol DownloaderImages {
   
}

extension DownloaderImages {
    
    func downloadImage(from urlString: String, completion: @escaping(UIImage?) -> () ) {
        
        if let url = URL(string: urlString) {
            
            DispatchQueue.global(qos: .background).async {
                
                guard let loadData = try? Data(contentsOf: url) else { return }
                
                if let loadedImage = UIImage(data: loadData) {
                    completion(loadedImage)
                    print("donwload image")
                }
            }
        }
    }
}


struct ImageSaver: DownloaderImages, FileManagerPath {
    
    func create(fileName name: String) -> String {
        return name.replacingOccurrences(of: "/", with: "") + ".png"
    }
    
    func save(from urlString: String, name: String) {
        
        downloadImage(from: urlString) { image in
            guard let dataImage = image?.pngData() else { return }
            
            do {
                try dataImage.write(to: self.documentsPath.appendingPathComponent(self.create(fileName: name)))
                print("\(self.create(fileName: name)) was saved to file mananager")
            } catch {
                print("Error")
            }
        }
    }
    
}
