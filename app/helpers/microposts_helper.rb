module MicropostsHelper

  def display(content)
    auto_link(sanitize(content))
  end
  
  def wrap(content, max_width = 30)
    content.split.map{ |s| wrap_long_string(s, max_width) }.join(' ')
  end

  private

    def wrap_long_string(text, max_width)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
    end
end
