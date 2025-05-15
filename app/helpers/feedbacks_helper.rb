module FeedbacksHelper
  # Вспомогательный метод для отображения поля формы с обработкой ошибок
  def form_group_with_error(form, field, options = {})
    css_class = "form-control"
    css_class += " is-invalid" if form.object.errors[field].any?
    field_options = {
      class: css_class,
      placeholder: t("feedback.new.help.#{field}")
    }.merge(options.except(:as, :type))
    
    content_tag :div, class: "mb-3" do
      concat form.label(field, t("feedback.new.#{field}"), class: "form-label")
      
      if options[:as] == :text_area
        concat form.text_area(field, field_options)
      elsif options[:type] == :email
        concat form.email_field(field, field_options)
      else
        concat form.text_field(field, field_options)
      end
      
      if form.object.errors[field].any?
        concat content_tag(:div, form.object.errors[field].join(', '), class: "invalid-feedback")
      end
    end
  end
end 