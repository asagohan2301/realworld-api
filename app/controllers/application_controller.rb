class ApplicationController < ActionController::API
  def not_found
    render plain: "このエンドポイントは存在しません。", status: :not_found
  end
end
