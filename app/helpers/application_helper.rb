module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Вкусные рецепты"
    if page_title.empty?
  	  base_title
    else 
      "#{page_title} | #{base_title}"		
    end
  end

  def avatar_for(user, size = '' )
      @avatar = user.avatar
      if @avatar.file.nil?
          @avatar_user = image_tag("logo.png", size: size, class: "avatar")
      else
          @avatar_user = image_tag(@avatar.url, size: size, class: "avatar")
      end
      return @avatar_user
  end  
 

end
