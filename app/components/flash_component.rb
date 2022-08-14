# frozen_string_literal: true

class FlashComponent < ViewComponent::Base
  TYPE_MAPPING = {
    error: "flash--error",
    warning: "flash--alert",
    notice: "flash--notice"
  }

  def initialize(msg:, type:, options: {})
    @msg = msg
    @type = type
    @options = options
  end

  def css_class
    [
      type_class
    ].reject(&:blank?).join(" ")
  end

  private

  def type_class
    TYPE_MAPPING[type.to_sym] || raise(NotImplementedError.new("#{type} not in allowed list"))
  end

  attr_reader :msg, :type, :options
end

