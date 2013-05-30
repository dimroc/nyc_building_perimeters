class PusherObserver < ActiveRecord::Observer
  observe :block

  def after_create(block)
    PusherService.push_block block
  end
end
