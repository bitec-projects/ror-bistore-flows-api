class Api::V1::WebhooksController < ActionController::API
  # Recebe mensagens da Evolution API
  def evolution
    payload = message_params
    # Exemplo: salvar dados recebidos em uma tabela Message
    message = Message.create!(
      number_id: payload[:numberId],
      remote_jid: payload[:key][:remoteJid],
      from_me: payload[:key][:fromMe],
      msg_id: payload[:key][:id],
      push_name: payload[:pushName],
      body: payload[:message][:conversation],
      msg_type: payload[:messageType]
    )

    # Enfileira o processamento assíncrono!
    WhatsappMessageEventJob.perform_async(message.id)

    head :ok
  rescue => e
    Rails.logger.error("Webhook Evolution Error: #{e.message}")
    head :unprocessable_entity
  end

  private

  def message_params
    params.permit(:numberId, :pushName, :messageType, key: {}, message: {})
  end
end
