# encoding: utf-8
class UploadController < ApplicationController

  #需要登录
  before_action :signed_in_user, only: [ :avatar_upload, :thumb_avatar_upload ]

  #丢失session先跳过对token的验证吧(临时方法)
  skip_before_filter :verify_authenticity_token, :only => [ :editor ]

  def editor
  	file = params[:imgFile]
	file_temp = file.tempfile
	file_name = file.original_filename
p '3333333333333333'
p env["PATH_INFO"]

	#上传
	result = ImageUnit::Upload.save_asset(file_temp,2)
	if result[:result]
	  item_id = params[:item_id] || 0
      result[:file_name] = file_name
      result[:relateable_id] = item_id
      result[:relateable_type] = params[:type]
      hash = collect_asset(result)
	  asset = Asset.new(hash)
	  if asset.save
		results = {
		  error: 0,
          #编辑器存生成的大图
		  url: asset_path(asset.thumb_big),
		  asset_id: asset.id
		}
	  else
		results = {
		  error: 1,
		  message: '上传失败!'
		}
	  end

	else
	  results = {
	    error: 1,
		message: result[:message]
	  }
	end

	render json: results.to_json
  end

  # 头像上传
  def avatar_upload
    #获得文件/格式
    file = params[:jUploaderFile].tempfile
	#上传
	result = ImageUnit::Upload.save_avatar(file)

	if result[:result]
	  if current_user.avatar_id('o').present?
		# 删除原头像
		del_asset_obj(current_user.avatar_id('o'))
	  end
	  current_user.avatar_id = [ result[:file_b_id], 'o' ]
	  if current_user.save
		# 由于用户信息修改，需要重新写入cookie
		sign_in(current_user)
		results = {
          success: true,
          #:format => avatar.second[:format],
          o_width: result[:file_b_width],
          o_height: result[:file_b_height]
		}
	  else
		results = {
			success: false,
			message: '上传失败!'
		}
	  end

	else
	  results = {
	    success: false,
		message: result[:message]
	  }
	end

	render text: results.to_json

  end


  # 保存头像缩略图
  def thumb_avatar_upload
    w,h,x1,y1 = params[:w].to_i,params[:h].to_i,params[:x1].to_i,params[:y1].to_i
    #获得原尺寸头像文件id
    file_id = current_user.avatar_id('o')
    #上传
    result = ImageUnit::Upload.save_thumb_avatar(file_id,w,h,x1,y1)
	if result.last
	  # 删除原头像
	  del_asset_obj(current_user.avatar_id('b')) if current_user.avatar_id('b').present?
	  del_asset_obj(current_user.avatar_id('m')) if current_user.avatar_id('m').present?
	  del_asset_obj(current_user.avatar_id('s')) if current_user.avatar_id('s').present?

	  current_user.avatar_id = [ result.first, 'b' ]
	  current_user.avatar_id = [ result.second, 'm' ]
	  current_user.avatar_id = [ result.third, 's' ]
	  if current_user.save
		#sign_in(current_user)
	    flash[:success] = '头像上传成功!'
	    redirect_to user_edit_avatar_path
	  else
	    flash[:error] = '缩略图保存失败!'
	    redirect_to user_edit_avatar_path
	  end
	else
	  flash[:error] = '缩略图生成失败!'
	  redirect_to user_edit_avatar_path
	end


  end


end
