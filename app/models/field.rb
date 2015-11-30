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



end
