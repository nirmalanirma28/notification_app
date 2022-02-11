class DeveloperMailer < ApplicationMailer
    def send_email(email)        
        @email = email        
        mail to: @email, subject: 'Used in emails for title'
    end    
end
