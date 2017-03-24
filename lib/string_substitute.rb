module StringSubstitute
  refine String do
    # Clean string of regex, return string. Returns string even if regex doesn't match
    def substitute(pattern, replacement)
      (val = gsub(pattern, replacement)) == true ? self : val
    end
  end
end
