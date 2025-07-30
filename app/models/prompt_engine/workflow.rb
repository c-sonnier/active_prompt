module PromptEngine
  class Workflow < ApplicationRecord
    self.table_name = "prompt_engine_workflows"

    validates :name, presence: true, uniqueness: true
    validates :steps, presence: true

    validate :validate_prompt_references

    def execute(variables = {})
      WorkflowEngine.new(self).execute(variables)
    end

    def execute_with_steps(variables = {})
      WorkflowEngine.new(self).execute_with_steps(variables)
    end

    private

    def validate_prompt_references
      return unless steps.present?

      steps.values.each do |prompt_name|
        unless PromptEngine::Prompt.exists?(slug: prompt_name)
          errors.add(:steps, "Referenced prompt '#{prompt_name}' does not exist")
        end
      end
    end
  end
end
