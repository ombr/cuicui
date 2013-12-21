module ApplicationHelper
  def bootstrap_class_for(flash_type)
    bootstrap = { success: 'success',
                  error: 'danger',
                  alert: 'warning',
                  notice: 'info'
    }
    if bootstrap[flash_type]
      "alert-#{bootstrap[flash_type]}"
    else
      'alert-notice'
    end
  end
end
