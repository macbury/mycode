class UzytkownikMailer < ActionMailer::Base
  

  def activate(uzytkownik)
    setup_email(uzytkownik)
    @subject    += 'Aktywacja konta'
    @body[:url]  = "http://0.0.0.0:3000/activate/#{uzytkownik.perishable_token}"
  end

  def forgot_password(sent_at = Time.now)
    subject    'UzytkownikMailer#forgot_password'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  protected
    def setup_email(uzytkownik)
      @recipients  = "#{uzytkownik.email}"
      @subject     = "[my-code.pl] "
      @sent_on     = Time.now
      @from        = ActionMailer::Base.smtp_settings[:from]
      @body[:uzytkownik] = uzytkownik
    end
end
