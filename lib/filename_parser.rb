class FilenameParser

  def self.normalize_name(filename)
    match = filename.match(/(.*)([\.|\[|\s|\(][0-9]{4}[\.|\]|\s|\)])/)
    match = filename.match(/(.*)([\.|\[|\s|\(][0-9]{4}[\.|\]|\s|\)]*)/) if !match
    return [nil, nil] unless match
    title = match[1]
    year = match[2]
    year = year.gsub(/\(|\)|\./, '')
    title = title.gsub(".", " ") 
    [title.strip, year.strip]
  end

end

