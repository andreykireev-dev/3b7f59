class ProcessProspectImportsJob < ApplicationJob
  queue_as :default

  def perform(prospect_import)
    prospect_import.run
  end
end
