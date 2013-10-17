# encoding: utf-8
class AssetsController < ApplicationController

   def serve
     gridfs_path = env["PATH_INFO"].gsub("/asset/", "")
	 p 'aaaaaaaaaaaa'
	 p gridfs_path
     begin
       #gridfs_file = asset_obj(gridfs_path)
	   
       if gridfs_file.present?
         self.response_body = gridfs_file.data
         self.content_type = gridfs_file.content_type
       else
         self.status = :file_not_found
         self.content_type = 'text/plain'
         self.response_body = 'file_not_found'
       end
     rescue
       self.status = :file_not_found
       self.content_type = 'text/plain'
       self.response_body = 'file_not_found'
     end
   end

  #ajax删除单个asset
  def destroy
    @type = (params[:type] || 1).to_i
    @asset = Asset.find(params[:id].to_i)
	respond_to do |f|
      if @asset.present?
        @asset.destroy
        @success = true
        f.xml { render :destroy, layout: false }
      else
        @success = false
        f.xml { render :destroy, layout: false } 
      end
    end
  end

  #ajax添加修改附件描述信息
  def ajax_save_desc
    @asset = Asset.find(params[:asset_id].to_i)
    if @asset.present?
      if @asset.update_attributes(desc: params[:desc])
        @success = true
        @note = '添加成功!'
      else
        @success = false
        @note = '添加失败!'
      end
    else
      @success = false
      @note = '对象不存在!'
    end

	respond_to do |f|
      f.xml { render :ajax_save_desc, layout: false }
    end

  end

end
