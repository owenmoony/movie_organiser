class FilenameParser

  def self.normalize_name(filename)
    match = filename.match(/(.*)([\.|\s|\(][0-9]{4}[\.|\s|\)])/)
    match = filename.match(/(.*)([\.|\s|\(][0-9]{4}[\.|\s|\)]*)/) if !match
    return [nil, nil] unless match
    title = match[1]
    year = match[2]
    year = year.include?("(") ? year : "(#{year.strip})"
    year = year.gsub(".", "") if year.include?(".")
    title = title.gsub(".", " ") if title.include?(".")
    [title.strip, year.strip]
  end

end

