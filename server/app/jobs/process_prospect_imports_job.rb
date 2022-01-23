class ProcessProspectImportsJob < ApplicationJob
  queue_as :default

  def perform(prospect_import)
    # Do something later
    prospect_import.run
  end
end
