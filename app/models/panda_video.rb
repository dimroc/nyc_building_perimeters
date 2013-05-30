class PandaVideo < ActiveRecord::Base
  attr_accessible :duration, :encoding_id, :height, :original_filename,
    :panda_id, :screenshot, :url, :width

  validates_uniqueness_of :panda_id

  has_one :block_video, dependent: :destroy, class_name: ::Block::Video

  scope :encoded, -> { where("panda_videos.url IS NOT NULL") }

  class << self
    def create_from_source(source_url)
      video = Panda::Video.create(source_url: source_url)
      panda = Panda::Encoding.find_by({
        :video_id => video.id,
        :profile_name => "h264"
      })

      PandaVideo.create({
        panda_id: video.id,
        encoding_id: panda.id,
        duration: panda.duration,
        height: panda.height,
        width: panda.width,
        original_filename: panda.video.original_filename,
        screenshot: panda.screenshots[0],
        url: panda.url
      })
    end

    def find_or_create_from_panda(panda_id)
      panda = Panda::Encoding.find_by({
        :video_id => panda_id,
        :profile_name => "h264"
      })

      video = PandaVideo.create({
        panda_id: panda.video_id,
        encoding_id: panda.id,
        duration: panda.duration,
        height: panda.height,
        width: panda.width,
        original_filename: panda.video.original_filename,
        screenshot: panda.screenshots[0],
        url: panda.url
      })
    end

    def destroy_dangling_panda_entries!
      pandas = Panda::Video.all
      exclusion_list = pandas.map(&:id).map { |e| "'#{e}'" }.join(',')
      to_destroy = PandaVideo.where("panda_id NOT IN (#{exclusion_list})")
      destroyed = to_destroy.to_a
      to_destroy.destroy_all
      destroyed
    end
  end

  def refresh_from_panda!
    panda = Panda::Encoding.find_by({
      :video_id => panda_id,
      :profile_name => "h264"
    })

    update_attributes(url: panda.url, screenshot: panda.screenshots[0]) if panda
  end

  # nil return value means does now know
  def exists_in_panda?
    Panda::Video.find(panda_id)
  rescue Panda::APIError => e
    false if e.message.include? "RecordNotFound"
  end

  def encoded?
    self.url.present?
  end
end
