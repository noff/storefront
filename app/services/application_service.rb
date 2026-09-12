# frozen_string_literal: true

# Базовый класс для сервисов
class ApplicationService
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end
end
