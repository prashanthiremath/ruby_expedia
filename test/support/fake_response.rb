class FakeResponse
  def initialize(options = {})
    options.each { |k, v| instance_variable_set("@#{k}", v) }
  end

  def method_missing(meth, *args, &blk)
    if args.empty?
      instance_variable_get("@#{meth}")
    else
      super
    end
  end
end
