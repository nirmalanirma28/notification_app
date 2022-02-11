class Msg91MessageService
    def send_sms(to_number, message)
      require 'msg91ruby'
      begin
        api = Msg91ruby::API.new(ENV['MSG91_AUTH_KEY'], ENV['MSG91_SENDER_ID'])
        api.send(to_number, message, 4)
      rescue  => e
      end
    end
end