require_relative '../../lib/model_base'

class Album < ModelBase
  finalize!
  belongs_to :artist
  has_many :tracks
end
