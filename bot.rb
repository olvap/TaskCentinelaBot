require 'telegram/bot'
require 'dotenv/load'

Telegram::Bot::Client.run(ENV['TOKEN']) do |bot|

  bot.listen do |message|
    next unless message.is_a?(Telegram::Bot::Types::Message) && message.text

    if message.text.include?(";") || message.text.include?("&")
      bot.api.send_message(chat_id: message.chat.id, text: "Parámetros inválidos.")

    else
      case message.text
      when /task add (.+)/i
        task_description = $1.strip

        command = "task add #{task_description}"
        output = `#{command}`

        bot.api.send_message(chat_id: message.chat.id, text: "Tarea añadida:\n#{output}")

      when /task (.+)/i
        params = $1.strip if $1
        output = `task #{params}`

        if output.length > 4096
          output = output[0..4092] + "..."
        end

        if output.strip.empty?
          output = "No hay tareas que coincidan con los parámetros proporcionados."
        end

        bot.api.send_message(chat_id: message.chat.id, text: output)

      when /task/i
        output = `task simple`

        if output.length > 4096
          output = output[0..4092] + "..."
        end

        if output.strip.empty?
          output = "No hay tareas que coincidan con los parámetros proporcionados."
        end

        bot.api.send_message(chat_id: message.chat.id, text: output || "Nada")
      end
    end

  end
end

