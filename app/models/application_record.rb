# require 'msg91ruby'
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # include Msg91MessageService
end
