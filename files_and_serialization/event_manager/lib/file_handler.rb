class FileHandler
  def initialize(path)
    @file_path = path
  end

  def create
    unless File.exist?(@file_path)
        raise "No such file or directory: #{@file_path.capitalize}"
    end

    return CSV.open(
        @file_path, 
        headers: true, 
        header_converters: :symbol
    )
  end
end