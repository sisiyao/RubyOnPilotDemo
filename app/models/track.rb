require_relative '../../lib/model_base'

class Track < ModelBase
  finalize!
  belongs_to :album
  has_one_through :artist, :album, :artist
end
