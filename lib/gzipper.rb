class Gzipper
  class << self
    def static_json
      Dir.glob("public/static/**/*.json") do |filename|
        puts "Compressing #{filename} to gzip"

        gzip_filename = "#{filename}.gz"
        FileUtils.rm_r(gzip_filename) if File.exists? gzip_filename

        Zlib::GzipWriter.open(gzip_filename) do |gz|
          gz.mtime = File.mtime(filename)
          gz.orig_name = filename
          gz.write IO.binread(filename)
        end
      end
    end
  end
end
