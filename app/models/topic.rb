class Topic < ActiveRecord::Base
  attr_accessible :description, :image, :title

  def set_image_filename
    self.image = rand(10**80).to_s(32) + ".jpg"
  end

  def image_date=(data)
    connect_s3!
    set_image_filename
    AWS::S3::S3Object.store(self.image , data , Rails.application.config.amazon_bucket)
  end

  def image_data
    return if image.nil?
    connect_s3!
    AWS::S3::S3Object.value(self.image , Rails.application.config.amazon_bucket)
  end

  def image_url=(url)
    begin
      u = URI.parse(url)
      im = open(u).read
      if(im.size != 0)
        self.image_data = im
      end
    rescue
    end
  end

  def image_url
  end

  private
  def connect_s3!
    @s3 ||= AWS::S3::Base.establish_connection!(:access_key_id => Rails.application.config.amazon_id , 
                                                :secret_access_key => Rails.application.config.amazon_secret)
  end


end
