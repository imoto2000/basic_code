# ImageUtils


require 'RMagick'

class ImageUtils
  def initialize(blob)
    blob
    @img = Magick::Image.from_blob(blob).shift
  end

  def text(str,font_size=60)
    text = Magick::Draw.new
    text.font_family = 'helvetica'
    text.pointsize = font_size
    text.gravity = Magick::CenterGravity
    text.annotate(@img, 0,0,2,2, str) {
      self.font_weight = Magick::BoldWeight
      self.fill = 'white'
    }
  end
  
  def width
    @img.columns
  end

  def height
    @img.rows
  end

  def limit_size_by_width(lim=240)
    if self.width > lim
      resize_by_width!(lim)
    end
    self
  end

  def resize!(width,height)
    @img = @img.resize(width,height)
    self
  end

  def resize_by_width!(width=240)
    height = (@img.rows.to_f * width.to_f / @img.columns.to_f).to_i
    @img = @img.resize(width, height)
    self
  end

  def resize_by_height!(new_height=240)
    new_width = (self.width.to_f * new_height.to_f / self.height.to_f).to_i
    @img = @img.resize(new_width, new_height)
    self
  end

  def square!
    #self.id
    lim = width <  height ? width : height    
    @img = @img.crop( Magick::CenterGravity,lim,lim)
    self
  end

  def rect!(w=800,h=350)
    resize_by_width!(w)
    x = 0
    y = (height * (2.0/5.0)) - (h / 2.0)
    @img = @img.crop(x,y,w,h)
    self
  end

  
  def fetch
    @img.to_blob
  end
  alias :data :fetch

  def mask(type=:q)
    mask1 = Magick::Image.read("#{RAILS_ROOT}/public/images/#{type}_mask_inner.png")[0]
    mask2 = Magick::Image.read("#{RAILS_ROOT}/public/images/#{type}_mask_outer.png")[0]
    square!
    resize_by_width!(48)
    clipped = mask1.composite(@img, Magick::CenterGravity ,Magick::InCompositeOp)
    @img = mask2.composite(clipped, Magick::CenterGravity ,Magick::OverCompositeOp)
    self
  end

  def circle(size=100)
    # notice! return gif
    masq = Magick::Image.new(width, height) {
      self.background_color = "white"
    }
    d = Magick::Draw.new
    # 10 is the corner's radius
    d.circle(width / 2, height / 2, 1 , height / 2)
    d.draw(masq)
    @img = @img.composite(masq, 0, 0, Magick::LightenCompositeOp)
    #@img = @img.composite(masq, 0, 0,Magick::OverCompositeOp)
    @img.fuzz = "3%"
    @img.format = "gif"
    @img = @img.resize(size,size)
    @img = @img.transparent("white")

    background_circle = Rails.cache.fetch("whitecircle/#{width},#{height}") do 
      masq2 = Magick::Image.new(width, height) {
        self.format = "gif"
        self.background_color = "yellow"
      }
      d2 = Magick::Draw.new
      d2.fill = "white"
      d2.circle(width / 2,height / 2 , 1 , height / 2)
      d2.draw(masq2)
      masq2.transparent("yellow")
    end
    @img = background_circle.composite(@img,0, 0,Magick::OverCompositeOp)
    self
  end

  def dark?(lim=0.5)
    max =  (2**16).to_f
    total = 0
    black = 0
    @img.color_histogram.each do |k,v|
      total += v
      n = 0
      if (((k.red + k.green + k.blue) / 3.0) / max ) < lim
        black += v 
      end
    end
    r = black.to_f / total.to_f
    r > 0.5
  end
end
