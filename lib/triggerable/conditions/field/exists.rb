module Triggerable
  module Conditions
    class Exists < FieldCondition
      def true_for? object
        v = field_value(object)
        @value ? v.present? : v.blank?
      end

      def scope
        "#{@field} IS #{'NOT ' if @value}NULL"
      end

      def desc
        "#{@field} exists"
      end
    end
  end
end