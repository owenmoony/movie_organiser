class FilenameParser

  def self.normalize_name(filename)
    match = filename.match(/(.*)([\.|\[|\s|\(][0-9]{4}[\.|\]|\s|\)])/)
    match = filename.match(/(.*)([\.|\[|\s|\(][0-9]{4}[\.|\]|\s|\)]*)/) if !match
    match = filename.match(/(.*)/) if !match
    return [nil, nil] unless match
    title = match[1]
    year = match[2]
    year = year.gsub(/\(|\)|\./, '').strip if year
    title = title.gsub(".", " ") 
    [title.strip, year]
  end

end

