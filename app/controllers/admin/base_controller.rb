# encoding: utf-8
class Admin::BaseController < ApplicationController

  #需要登录
  before_filter :authenticate_admin

end

