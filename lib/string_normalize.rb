# CLEAN MP, doesn't override core method.
class String
  # Clean string of regex, return string. Returns string even if regex doesn't match
  def normalize(pattern, replacement)
    (val = gsub(pattern, replacement)) == true ? self : val
  end
end
