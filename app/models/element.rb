class Element < ActiveRecord::Base
  belongs_to :folio
  validate :any_present?
  has_attached_file :file,
   styles: {
     thumb: '100x100>',
      square: '200x200#'
    }

  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/

  def any_present?
    if %w(title file element_link description).all?{|attr| self[attr].blank?}
    errors.add :base, "Error message"
    end
  end

end
