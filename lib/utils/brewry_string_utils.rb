module BrewryStringUtils
  # This is a ruby refinement. Only works in ruby >= 2.0
  # This method is monkey patched into String when using Rails, but in this
  # fashion it will always be scoped to the BrewryStringUtils module.
  refine String do
    def underscore
      self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end
