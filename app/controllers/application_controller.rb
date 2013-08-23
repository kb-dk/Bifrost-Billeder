class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions. 

  layout 'blacklight'

  protect_from_forgery

  # Will only do authentication if the user is not allowed to act anonymously
  def authenticate_conditionally
    authenticate unless can? :be_anonymous, User
  end

  # Will always do authentication
  def authenticate
    unless session[:user_id]
      session['return_url'] = request.url
      logger.debug request.url
      # Recreate user abilities on each login
      @current_ability = nil
      redirect_to polymorphic_url(:new_user_session)
    end
  end

  helper_method :guest_user, :current_or_guest_user

  def current_user
    if session[:user]
      user = User.new
      user.pid = session[:user].extra.alephPID
      #    user.name = session[:user].extra.attributes[0]['gn'] + ' ' + session[:user].extra.attributes[0]['sn']

      user.gn = session[:user].extra.gn.to_s
      user.sn = session[:user].extra.sn.to_s
      user.name = user.gn + ' ' + user.sn

      return user
    end
  end

  def guest_user
    User.new
  end

  def current_or_guest_user
    current_user || guest_user
  end


  #redirect to some sane access denied page
  # Todo: create that page
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end


  # Call this to bail out quickly and easily when something is not found.
  # It will be rescued and rendered as a 404
  def not_found
    raise ActionController::RoutingError.new 'Not found'
  end

  # Render 401
  def deny_access
    render(:file => 'public/401', :format => :html, :status => :unauthorized, :layout => nil)
  end

  # Render a 404 response. This should not be called directly. Instead you should call #not_found
  # which will raise exception, rescue it and call this render method
  def render_not_found(exception)
    render :file => 'public/404', :format => :html, :status => :not_found, :layout => nil
  end

  # set the locale
  before_filter :set_locale


  def set_locale
    logger.debug "app_controller set_locale params[:locale]=" + params[:locale] + " I18n.default_locale=" +  I18n.default_locale.to_s rescue nil
    I18n.locale =  params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
end
