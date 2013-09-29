module RubyExpedia
  class Hotel
    # Public: An Exception to be raised from all EAN API-related errors.
    class EANException < Exception
      # Internal: Setter for the recovery information.
      attr_writer :recovery

      # Public: Getter for the recovery information.
      attr_reader :recovery

      # Internal: Setter for the error type.
      attr_writer :type

      # Public: Getter for the error type..
      attr_reader :type

      # Internal: Create a new EAN exception.
      #
      # message - The String error message returned by the API.
      # type    - The Symbol type of the error.
      def initialize(message, type = nil)
        @type = type
        super(message)
      end

      # Public: Check if the error is recoverable. If it is, recovery information
      #         is in the attribute recovery.
      #
      # Returns a Boolean based on whether the error is recoverable.
      def recoverable?
        @recovery.is_a?(Hash)
      end
    end
  end
end
