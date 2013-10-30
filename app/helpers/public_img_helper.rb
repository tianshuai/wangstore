# encoding: utf-8
module PublicImgHelper

  #默认头像地址
  def default_avatar(t='s')
	case t
    when 's' then img_url = 'avatar_small.gif'
    when 'm' then img_url = 'avatar_medium.gif'
    when 'b' then img_url = 'avatar_big.gif'
    else
	  img_url = 'avatar_small.gif'
	end
  end

end
