module ApplicationHelper
	def errors_for(object)
    if object.errors.any?
        content_tag(:div, class: "panel panel-danger") do
            concat(content_tag(:div, class: "panel-heading") do
                concat(content_tag(:h4, class: "panel-title") do
                    concat "#{pluralize(object.errors.count, "error")} prohibited this #{object.class.name.downcase} from being saved:"
                end)
            end)
            concat(content_tag(:div, class: "panel-body") do
                concat(content_tag(:ul) do
                    object.errors.full_messages.each do |msg|
                        concat content_tag(:li, msg)
                    end
                end)
            end)
        end
    end
end

def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

    def package_name(id)
        if id == 1
            "Group Picture"
        elsif id ==2
            "Senior Portrait"
        elsif id == 3
            "Graduation Portrait"
        end
    end

    def free(price)
        if price == 0
            true
        else
            false
        end
    end
end
