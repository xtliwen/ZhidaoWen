# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(user_path(current_user))
      flash[:notice] = "登录成功"
      Log.add("<a target='_blank' href='users/#{current_user.id}'>#{current_user.login}</a>在#{Time.now.to_s(:db)}到访过知道问!")
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "你已经退出了."
    redirect_back_or_default('/')
  end

end
