module Conditions
  class IsNot < FieldCondition
    def true_for? object
      field_value(object) != @value
    end

    def scope
      "#{@field} <> #{sanitized_value}"
    end
  end
end