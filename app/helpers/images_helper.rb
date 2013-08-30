# encoding: utf-8
module ImagesHelper

  def create_image(filename)
    doc = REXML::Document.new File.new(filename)
    #logger.debug  doc.root.size
    @image = Image.new()

    extracted_elements = make_hash(doc.root)
    @image.record_id = extracted_elements['record_id']
    @image.title = extracted_elements['Titel']
    @image.author = extracted_elements['Ophav']
    @image.opstilling = extracted_elements['Opstilling']
    @image.genre = extracted_elements['Genre']
    locals = extracted_elements['Lokalitet'] || ''
    @image.local = locals.is_a?(Array) ? locals.uniq : locals.split(', ')
    categories = extracted_elements['Categories'].split(', ')  || ''
    @image.category = categories.is_a?(Array) ? categories.uniq : categories.split(', ')
    @image.fileidentifier = extracted_elements['Record Name']
    @image.imagetype = extracted_elements['Materialebetegnelse']
    @image.imagetype ||= extracted_elements['Generel materialebetegnelse']
    @image.date_txt = extracted_elements['Time']
    @image.date_start = extracted_elements['År']
    @image.path_to_image = extracted_elements['Asset Reference']
    @image.description = extracted_elements['Note']
    @image.keywords = extracted_elements['Emneord']
    @image.person = extracted_elements['Person']
    @image.copyright = extracted_elements['Copyright']

    @image
  end

  private

  def make_hash(root)
    extracted_elements = Hash.new
    root.elements.each('field/value') do |element|
      if extracted_elements.has_key? element.parent.attributes['name']
        if extracted_elements[element.parent.attributes['name']].is_a?(Array)
          value = extracted_elements[element.parent.attributes['name']]
        else
          value = [extracted_elements[element.parent.attributes['name']]]
        end
        value << element.text
      else
        value = element.text
      end

      extracted_elements[element.parent.attributes['name']] = value
    end

    #puts "Extracted file : #{extracted_elements.inspect.to_s}"
    extracted_elements
  end

end
