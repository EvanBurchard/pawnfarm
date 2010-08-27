class TweetScheme < Scheme

  def self.model_name
    name = "scheme"
    name.instance_eval do
      def plural; pluralize; end
      def singular; singularize; end
    end
    return name
  end
end
