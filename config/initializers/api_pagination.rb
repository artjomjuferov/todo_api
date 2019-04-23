ApiPagination.configure do |config|
  config.page_param do |params|
    params[:page][:number] if params[:page].is_a?(ActionController::Parameters)
  end
end
