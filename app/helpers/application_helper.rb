module ApplicationHelper
  def svg(name)
    content_tag(:object, nil, data: asset_url("svg/#{name}.svg"), type: "image/svg+xml")
  end
end
