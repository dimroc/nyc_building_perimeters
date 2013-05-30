namespace :panda do
  desc "Refresh database with data from panda about encodings"
  task :refresh => :environment do
    PandaVideo.find_each do |panda_video|
      puts "Refreshing #{panda_video.original_filename} with id #{panda_video.panda_id}"
      panda_video.refresh_from_panda!
    end
  end

  desc "Remove all videos that do no exist in panda"
  task :purge => :environment do
    destroyed = PandaVideo.destroy_dangling_panda_entries!
    destroyed.each do |panda_video|
      puts "Purged video #{panda_video.original_filename} with id #{panda_video.panda_id}"
    end
  end
end
