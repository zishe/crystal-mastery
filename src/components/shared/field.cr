module Shared::Field
  # This method is used to make it easier to render the same fields styles
  # throughout your app
  #
  # ## Usage
  #
  #     render_field(form.email) { |i| email_input i }
  #     render_field(form.email) { |i| email_input i, autofocus: "true" }
  #
  # ## Customization
  #
  # You can customize this method so that fields render like you expect
  # For example, you might wrap it in a div with a "field-wrapper" class.
  #
  #    div class: "field-wrapper"
  #      label_for field
  #      yield field
  #      errors_for fields
  #    end
  #
  # You may also want to have more than one method if you render fields
  # differently in different parts of your app, e.g. `compact_field`
  private def field(field, hide_label : Bool = false, hide_errors : Bool = false, label_options = NamedTuple.new)
    div class: "field-block #{error_class(field)}" do
      unless hide_label
        label_for field, **label_options
      end

      yield field

      unless hide_errors
        errors_for field
      end
    end
  end

  def error_class(field)
    unless field.valid?
      "-has-error"
    end
  end

  def errors_for(field : LuckyRecord::FillableField)
    unless field.valid?
      para class: "help is-danger" do
        label_text = LuckyInflector::Inflector.humanize(field.name.to_s)
        text "#{label_text} #{field.errors.join(", ")}"
      end
    end
  end
end
