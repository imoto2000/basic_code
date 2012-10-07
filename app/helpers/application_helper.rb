# -*- coding:utf-8 -*-

module ApplicationHelper

  def format_with_link(txt)
    txt = h(txt)
    txt.gsub!(/\r\n|\n|\r/,"<br>")
    txt.gsub!(/https?:\/\/[\w\-,%&=~\?\.\/;]+/){ |m|
      if m.match(/youtube\.com|youtu\.be/)
        youtube_link(m)
      else
        "<a href='#{m}'>#{m}</a>"
      end
    }
    raw(txt)
  end

  def youtube_link(url)
    if url.match(/v=([\w\-]+)/)
      embed_url = "http://www.youtube.com/embed/#{$1}?wmode=transparent"
    elsif url.match(/embed/)
      embed_url = url
    elsif url.match(/youtu\.be\/([\w\-]+)/)
      embed_url = "http://www.youtube.com/embed/#{$1}?wmode=transparent"
    end
    %[<iframe width="400" height="200" src="#{embed_url}" frameborder="0" allowfullscr\
een></iframe>]
  end

end
