require_relative '../../lib/model_base'

class Artist < ModelBase
  finalize!
  has_many :albums
  has_many_through :tracks, :albums, :tracks

  def valid?
    valid = true
    if self.name == ""
      errors << "Name can't be blank"
      valid = false
    end

    if self.image_url == ""
      errors << "Image url can't be blank"
      valid = false
    end
    valid
  end
end
