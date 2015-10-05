class Template < ActiveRecord::Base
  
  has_many :fields, dependent: :destroy
  has_many :fonts, through: :fields
  has_many :pdfs, dependent: :destroy
  
  validates_presence_of :name

  accepts_nested_attributes_for :fields, allow_destroy: true
  accepts_nested_attributes_for :pdfs, allow_destroy: true
  
  def prompts
    fields.where(column: 'prompt')
  end
end
