class Block::Video < Block
  belongs_to :video, class_name: ::PandaVideo, foreign_key: :panda_video_id

  accepts_nested_attributes_for :video

  delegate :encoded?, to: :video, allow_nil: true

  class << self
    def encoded
      joins("INNER JOIN panda_videos ON blocks.panda_video_id = panda_videos.id").
        where("panda_videos.url IS NOT NULL")
    end
  end

  def as_json(options={})
    inclusion = {
      include: { "video" => { only: [:url, :screenshot, :duration] }}
    }

    super(options.merge(inclusion))
  end
end
