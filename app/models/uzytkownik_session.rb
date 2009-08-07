class UzytkownikSession < Authlogic::Session::Base
  consecutive_failed_logins_limit 50
  failed_login_ban_for 1.hour
  
  remember_me_for 7.days
  
  allow_http_basic_auth true
  
  generalize_credentials_error_messages
end