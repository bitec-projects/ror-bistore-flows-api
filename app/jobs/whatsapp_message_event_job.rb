class WhatsappMessageEventJob
  include Sidekiq::Job
  sidekiq_options queue: :'whatsapp-messages', retry: 5

  # Este método é executado de forma assíncrona pelo Sidekiq
  def perform(message_id)
    # Busca a mensagem pelo ID salvo previamente no banco
    message = Message.find(message_id)

    # Aqui você implementa sua lógica de processamento
    # Exemplo mínimo: logar, ou criar/atualizar registros de venda a partir da mensagem
    Rails.logger.info("Processando mensagem WhatsApp: #{message.inspect}")

    # Exemplo idempotente: não criar duplicados!
    # Lógica real: Sale.upsert_from_message(message) OU qualquer processamento que desejar

    # Comente aqui seu parsing ou processamento de venda
    # ---
    # Exemplo: cria uma venda só se não existe para essa message
    # Sale.find_or_create_by!(message_id: message.id) do |sale|
    #   sale.client_name = message.push_name
    #   sale.amount = extrair_valor(message.body)
    #   sale.occurred_at = message.created_at
    # end
    # ---

    # Marque a mensagem como processada (opcional, se for útil para tracking)
    # message.update!(processed: true)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn("Mensagem não encontrada: #{message_id}")
  rescue => e
    Rails.logger.error("Erro ao processar mensagem WhatsApp: #{e.message}")
    raise e # Garante retry automático do job se falhar
  end
end
