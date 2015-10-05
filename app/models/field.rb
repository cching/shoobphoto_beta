class Field < ActiveRecord::Base
	def self.align_options
    {
      'Left' => 'left',
      'Center' => 'center',
      'Right' => 'right'
    }
  end
  
  
  belongs_to :template
  belongs_to :font


  validates_presence_of :name, :column, :x, :y, :width, :height, :text_size, :color
  validates_format_of :color, with: /[0-9a-fA-F]{6}/
  validates_inclusion_of :align, in: Field.align_options.values,
    message: 'is not a valid align setting'
  validates_numericality_of :x, :y, :width, :height, :text_size
  validates_uniqueness_of :name, scope: :template_id
end
