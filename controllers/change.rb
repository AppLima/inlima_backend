require 'json'
require_relative '../DAO/administrator'
require_relative '../DAO/change'

class ChangeController
  #def record_change(token, data)
  def record_change(data)
    begin
      #usuario = verificar_token(token)
      changes = ChangeDAO.create({
        administrator_id: 1,
        complaint_id: data[:complaint_id],
        status_id: data[:status_id]
      })
      { success: true, message: "Cambio registrado", data: queja }.to_json
    rescue => e
      puts "Error: #{e.message}"
      { success: false, message: "Error al crear el cambio" }.to_json
    end
  end
end
