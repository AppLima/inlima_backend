require 'net/smtp'
require 'json'
require 'erb'
require 'dotenv/load'

module Notifier
  SMTP_SERVER = 'smtp.gmail.com'
  SMTP_PORT = 587
  SMTP_USER = ENV['USER_EMAIL']
  SMTP_PASSWORD = ENV['USER_PASSWORD']
  FROM_EMAIL = 'inLimaApp@gmail.com'

  def self.send_mail(to, subject, body)
    message = <<~MESSAGE_END
      From: InLima <#{FROM_EMAIL}>
      To: <#{to}>
      Subject: #{subject}
      MIME-Version: 1.0
      Content-type: text/html

      #{body}
    MESSAGE_END

    Net::SMTP.start(SMTP_SERVER, SMTP_PORT, 'localhost', SMTP_USER, SMTP_PASSWORD, :login) do |smtp|
      smtp.send_message message, FROM_EMAIL, to
    end
  rescue StandardError => e
    puts "Error sending email: #{e.message}"
    { success: false, message: "Failed to send email: #{e.message}" }
  end

  def self.notify_status_change(email, estado, ticket, nombre, asunto, fecha)
    subject = "INLIMA: NOTIFICACIÓN CAMBIO DE ESTADO DE QUEJA - TICKET IL00#{ticket}"
    
    body = <<~HTML
      <div style="
          font-family: Arial, sans-serif; 
          max-width: 600px; 
          margin: 30px auto; 
          border: 1px solid #e0e0e0; 
          padding: 30px; 
          border-radius: 15px; 
          background-color: #ffffff; 
          box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      ">
          <div style="text-align: center; padding: 20px 0;">
              <img src="https://i.imgur.com/h6xBALR.png" alt="INLIMA Logo" style="width: 150px; margin-bottom: 20px;">
          </div>
          <p style="font-size: 18px; color: #444; margin: 20px 0;">
              Hola <strong style="color: #C52233;">#{ERB::Util.html_escape(nombre)}</strong>,
          </p>
          <p style="font-size: 16px; color: #555; margin: 20px 0;">
              Queremos informarte que el estado de tu queja ha cambiado a 
              <strong style="color: #28a745;">#{ERB::Util.html_escape(estado)}</strong>.
          </p>
          <div style="font-size: 16px; color: #555; margin: 20px 0; background-color: #f8f9fa; padding: 15px; border-left: 4px solid #C52233;">
              <p><strong>Detalles de su queja:</strong></p>
              <p><strong>Asunto:</strong> #{ERB::Util.html_escape(asunto)}</p>
              <p><strong>Fecha:</strong> #{ERB::Util.html_escape(fecha)}</p>
          </div>
          <p style="font-size: 16px; color: #555; margin: 20px 0;">
              Si tienes alguna pregunta o necesitas más información, no dudes en ponerte en contacto con nosotros.
          </p>
          <p style="font-size: 16px; color: #555; margin: 20px 0;">
              Atentamente,<br>
              <strong>El equipo de InLima</strong>
          </p>
          <footer style="margin-top: 30px; font-size: 14px; color: #777; text-align: center; border-top: 1px solid #e0e0e0; padding-top: 20px;">
              © 2024 INLIMA. Todos los derechos reservados.
          </footer>
      </div>
    HTML

    send_mail(email, subject, body)
  end

  def self.notify_welcome(email, nombre)
    subject = "Bienvenido a INLIMA, #{nombre}!"
    
    body = <<~HTML
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 30px auto; border: 1px solid #e0e0e0; padding: 30px; border-radius: 15px; background-color: #ffffff; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
        <div style="text-align: center; padding: 20px 0;">
            <img src="https://i.imgur.com/h6xBALR.png" alt="INLIMA Logo" style="width: 150px; margin-bottom: 20px;">
        </div>
        <p style="font-size: 18px; color: #444; margin: 20px 0;">
            ¡Hola <strong style="color: #C52233;">#{ERB::Util.html_escape(nombre)}</strong>!
        </p>
        <p style="font-size: 16px; color: #555; margin: 20px 0;">
            Bienvenido a INLIMA, estamos encantados de tenerte con nosotros. Esperamos que disfrutes de la experiencia y puedas hacer uso de nuestras herramientas para gestionar tus quejas de forma rápida y eficiente.
        </p>
        <p style="font-size: 16px; color: #555; margin: 20px 0;">
            Atentamente,<br>
            <strong>El equipo de InLima</strong>
        </p>
      </div>
    HTML

    send_mail(email, subject, body)
  end

  def self.notify_verification_code(email, code)
    subject = "Código de Verificación para INLIMA"
    
    body = <<~HTML
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 30px auto; border: 1px solid #e0e0e0; padding: 30px; border-radius: 15px; background-color: #ffffff; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
        <div style="text-align: center; padding: 20px 0;">
            <img src="https://i.imgur.com/h6xBALR.png" alt="INLIMA Logo" style="width: 150px; margin-bottom: 20px;">
        </div>
        <p style="font-size: 18px; color: #444; margin: 20px 0;">
            Utiliza el siguiente código de verificación para continuar con el proceso de registro o verificación en INLIMA:
        </p>
        <div style="font-size: 24px; color: #C52233; font-weight: bold; text-align: center; padding: 15px; background-color: #f8f9fa; border-radius: 10px;">
            #{ERB::Util.html_escape(code)}
        </div>
        <p style="font-size: 16px; color: #555; margin: 20px 0;">
            Si no solicitaste este código, por favor ignora este mensaje.
        </p>
        <p style="font-size: 16px; color: #555; margin: 20px 0;">
            Atentamente,<br>
            <strong>El equipo de InLima</strong>
        </p>
      </div>
    HTML
  
    send_mail(email, subject, body)
  end
  
end
