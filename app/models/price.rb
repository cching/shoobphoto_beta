class Price < ActiveRecord::Base
  belongs_to :school
  belongs_to :option
  belongs_to :extra
  belongs_to :package
end
