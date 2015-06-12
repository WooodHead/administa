module Administa
  module Controller
    extend ActiveSupport::Concern

    included do
      include ::Administa::Actions::Index
      include ::Administa::Actions::Show
      include ::Administa::Actions::New
      include ::Administa::Actions::Create
      include ::Administa::Actions::Edit
      include ::Administa::Actions::Update
      include ::Administa::ErrorHandlers

      layout 'administa/application'
      respond_to :html, :json

      class_attribute :model,   :instance_write => false
    end

    module ClassMethods

      # Configure Administa options
      #
      #  model: (required)
      #
      #  index: {
      #    limit: 20,
      #    order: :id,
      #    columns: [:id, :name]
      #  }
      #
      def administa(model:,  **options)
        self.model = Administa::Model.new(self, model, options)
      end
    end
  end
end
