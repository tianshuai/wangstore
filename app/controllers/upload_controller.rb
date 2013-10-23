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
	user_id = params[:user_id].to_i

	#上传
	result = ImageUnit::Upload.save_asset(file_temp,2, { user_id: user_id, filename: file_name, img_kind: ['b'] })
	if result[:result]
	  item_id = params[:item_id] || 0
      result[:name] = file_name
      result[:relateable_id] = item_id
      result[:relateable_type] = params[:type]
	  result[:kind] = params[:kind] || 2
      hash = collect_asset(result)
	  asset = Asset.new(hash)
	  if asset.save
		results = {
		  error: 0,
          #编辑器存生成的大图
		  url: File.join(domain_base, asset.url('b')),
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


end
