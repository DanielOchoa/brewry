module Brewry
  # Exceptions raised by Brewry inherit from Error
  class Error < StandardError; end

  # Exception raised when no api key was set
  class MissingApiKey < Error; end
end
