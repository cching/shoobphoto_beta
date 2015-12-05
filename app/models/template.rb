class Template < ActiveRecord::Base
  
  has_many :fields, dependent: :destroy
  has_many :fonts, through: :fields
  has_many :pdfs, dependent: :destroy
  has_many :types, through: :pdfs
  has_many :template_columns
  has_many :columns, through: :template_columns
  has_many :export_datas
  
  validates_presence_of :name

  accepts_nested_attributes_for :fields, allow_destroy: true,
    :reject_if => proc { |a| a['x'].blank? }
  accepts_nested_attributes_for :pdfs, allow_destroy: true
  
  def prompts
    fields.where(column: 'prompt')
  end
end
