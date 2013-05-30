namespace :block do
  desc "Update zip codes and neighborhoods of existing blocks"
  task :update_metadata => :environment do |t, args|
    Block.find_each do |block|
      block.update_zip_code!
      block.update_neighborhood!
    end
  end
end
