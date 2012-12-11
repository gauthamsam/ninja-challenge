require 'open-uri'

class ReportsPdf < Prawn::Document
  def initialize(test, charts)
    super()
    @test = test
    
    insert_text
    charts.each do |chart|
      @chart = chart
      insert_chart
    end 
    
    insert_footer
  end

  def insert_text
    text "Report for " + @test.name, :indent_paragraphs => 200,  :size => 20
    move_down 50
  end
  
  def insert_chart
    image_name = 'chart.jpg'                                        
    # Create the image first and then give that path to the image renderer.
    create_image(image_name)    
    image image_name    
    delete_image(image_name)
  end
  
  # Create a temporary image to render in the pdf.
  def create_image(image_name)
    open(image_name, 'wb') do |file|
      file << open(URI.escape(@chart)).read
    end
  end
  
  # Delete the image after it has been rendered in the pdf.
  def delete_image(image_name)
    File.delete(image_name)
  end
  
  def insert_footer
    move_down 100
    text "Copyright Ninja Challenge 2012.", :indent_paragraphs => 200
  end

end