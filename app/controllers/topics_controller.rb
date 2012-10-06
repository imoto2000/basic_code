class TopicsController < ApplicationController
  def index
    @topics = Topic.order("created_at DESC")
  end

  def update
    t = Topic.new(params[:topic])
    t.image_date=(params[:topic][:image].read)
    if t.valid?
      t.save
      redirect_to topics_index_path and return
    else
      render :text => "Error"
    end
  end
  
  def image 
    data = Rails.cache.fetch("topic_image/#{params[:id]}",:expires_in => 10.days){
      @t = Topic.find(params[:id])
      img = ImageUtils.new(@t.image_data)
      data = img.fetch
    }
    send_data data , :type => "image/jpeg" , :disposition => "inline"
  end

  def image_thumbnail
    _width = params[:width].to_i
    _height = params[:height].to_i
    
    data = Rails.cache.fetch("topic_thumbnail/#{params[:id]}",:expires_in => 10.days){
      @t = Topic.find(params[:id])
      img = ImageUtils.new(@t.image_data)
      img.resize!(_width,_height)
      data = img.fetch
    }
    send_data  data , :type => "image/jpeg" , :disposition => "inline"
  end

  def show
    @topic = Topic.find(params[:id])
    @pv = PV.count_up(params[:id])
  end

  def delete_cache
    Rails.cache.delete("topic_image/#{params[:id]}")
    Rails.cache.delete("topic_thumbnail/#{params[:id]}")
    redirect_to :root_path and return
  end

end
