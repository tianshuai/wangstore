# encoding: utf-8
module PublicImgHelper

  #图片对象
  def asset_obj(path)
	Mongoid::GridFS.get(path)
  end
 
  #删除mongodb附件
  def del_asset_obj(id)
	Mongoid::GridFS.delete(id) if id.present?
  end

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

  #取头像链接(user参数为用户对象；t参数为大中小，分为用'b','m','s'表示，最后为可选参数，如：:alt=>'',:width=>'',:class=>''等等)
  def user_avatar_tag(user,t,options={})
    if user.present? and user.avatar_id(t).present? and asset_obj(user.avatar_id(t)).present?
	  url = asset_path(user.avatar_id(t))
	  img = image_tag(url,options)
	else
	  img = image_tag(default_avatar(t),options)
    end
  end

  #获取附件表图片(原图)
  def asset_o_tag(asset,options={})
    if asset.present?
	  url = asset_path(asset.original_file)
	  img = image_tag(url,options)
	else
	  img = image_tag(default_avatar(t),options)
    end
  end

  #获取附件表图片(大图)
  def asset_b_tag(asset,options={})
    if asset.present?
	  url = asset_path(asset.thumb_big)
	  img = image_tag(url,options)
	else
	  img = image_tag(default_avatar(t),options)
    end
  end

  #获取附件表图片(中图)
  def asset_m_tag(asset,options={})
    if asset.present?
	  url = asset_path(asset.thumb_middle)
	  img = image_tag(url,options)
	else
	  img = image_tag(default_avatar(t),options)
    end
  end

  #获取附件表图片(小图)
  def asset_s_tag(asset,options={})
    if asset.present?
	  url = asset_path(asset.thumb_small)
	  img = image_tag(url,options)
	else
	  img = image_tag(default_avatar(t),options)
    end
  end

end
