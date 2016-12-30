module ApplicationHelper
  def svg(name)
    file_path = "#{Rails.root}/app/assets/images/svg/#{name}.svg"
    return File.read(file_path).html_safe if File.exists?(file_path)
        '(not found)'
    # tag(:object, data: file_path, type: "image/svg")
  end
end


# def svg(name)
#   file_path = "#{Rails.root}/public/images/svg/#{name}.svg"
#   tag(:object, data: file_path, type: "image/svg+xml" )
#   return File.read(file_path).html_safe if File.exists?(file_path)
#   '(not found)'
# end

# def svg(name)
#   File.open("public/images/svg/#{name}.svg", "rb") do |file|
#     raw file.read
#   end
# end
