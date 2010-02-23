class Child < CouchRestRails::Document
  use_database :child
  require "uuidtools"
  include CouchRest::Validation


  def create_unique_id (user_name)
    unknown_location = 'xxx'
    truncated_location = self['last_known_location'].blank? ? unknown_location : self['last_known_location'].slice(0,3).downcase
    self['unique_identifier'] = user_name + truncated_location + UUIDTools::UUID.random_create.to_s.slice(0,5)
  end


  def photo= photo_file
    return unless photo_file.respond_to? :content_type
    @file_name = photo_file.original_path
    if (has_attachment? :photo)
      update_attachment(:name => "photo", :content_type => photo_file.content_type, :file => photo_file)
    else
      create_attachment(:name => "photo", :content_type => photo_file.content_type, :file => photo_file)
    end
  end

  def photo
    read_attachment "photo"
  end

  def valid?  context=:default
    valid = true

    if (!/([^\s]+(\.(?i)(jpg|png|gif|bmp))$)/.match(@file_name))
      valid = false
      errors.add("photo", "Please upload a valid photo file (jpg or png) for this child record")
    end

    if self["last_known_location"].blank?
      valid = false
      errors.add("last_known_location", "Last known location cannot be empty")
    end


    return valid
  end

  def update_properties_from child
    child.each_pair do |name, value|
      self[name] = value unless value.blank?
    end
  end

end