# Adds group_by_index method.
# @see IndexGroupable#group_by_index
module IndexGroupable
  # Groups values with keys in the pattern /(\d+)\z/ together
  # @param fields [Hash]
  # @return [Array(Array)]
  def group_by_index(fields)
    # returns an array of hashes
    # Could use #partition?
    fields.group_by { |k, _| /(\d+)\z/.match(k).captures[0] }
      .values.map { |group| Hash[group] }
  end
end

