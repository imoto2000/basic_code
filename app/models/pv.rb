class PV
  include Mongoid::Document
  field :view , :type => Integer
  field :topic_id , :type => Integer

  def self.count_up(_id)
    if PV.where(:topic_id => _id).blank?
      pv = self.create(:topic_id => _id , :view => 1)
    else
      pv = PV.where(:topic_id => _id).first
      pv.inc(:view,1)
    end
    pv
  end
  
  def self.hello
    p "hello!!!"
  end

end
