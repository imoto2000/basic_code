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

  def show
  end
end
