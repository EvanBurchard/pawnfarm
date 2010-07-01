class AtScheme < Scheme
  validates_presence_of (:target)

  def self.model_name
    name = "scheme"
    name.instance_eval do
      def plural; pluralize; end
      def singular; singularize; end
    end
    return name
  end
end
