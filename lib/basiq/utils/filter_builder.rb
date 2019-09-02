# frozen_string_literal: true

module Basiq
  class FilterBuilder
    def initialize(filters = [])
      @filters = filters
    end

    def eq(field, value)
      @filters.append(field + ".eq('" + value + "')")
      self
    end

    def gt(field, value)
      @filters.append(field + ".gt('" + value + "')")
      self
    end

    def gteq(field, value)
      @filters.append(field + ".gteq('" + value + "')")
      self
    end

    def lt(field, value)
      @filters.append(field + ".lt('" + value + "')")
      self
    end

    def lteq(field, value)
      @filters.append(field + ".lteq('" + value + "')")
      self
    end

    def bt(field, value_one, value_two)
      @filters.append(field + ".bt('" + value_one + "','" + value_two + "')")
      self
    end

    def to_s
      @filters.join(',')
    end

    def get_filter
      'filter=' + to_s
    end

    def set_filter(filters)
      @filters = filters
      self
    end
  end
end
