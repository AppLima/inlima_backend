require 'json'
require_relative '../DAO/administrator'
require_relative '../DAO/change'
require_relative '../DAO/complaint'
require_relative '../DAO/user'
require_relative '../DAO/subject'
require_relative '../DAO/status'
require_relative '../helpers/auth_helper'
require_relative '../helpers/notifier'

class ChangeController
  include AuthHelper

  def record_change(token, data)
    begin
      usuario = verificar_token(token)
    rescue => e
      puts "Error al verificar el token: #{e.message}"
      return { success: false, message: "Error al verificar el token" }.to_json
    end

    begin
      change = ChangeDAO.create({
        administrator_id: usuario[:id],
        complaint_id: data[:complaint_id],
        status_id: data[:status_id]
      })
      complaint = ComplaintDAO.update_estado(data[:complaint_id], status_id: data[:status_id])
    rescue => e
      puts "Error al crear el cambio: #{e.message}"
      return { success: false, message: "Error al crear el cambio" }.to_json
    end

    begin
      complaint = ComplaintDAO.find_one(data[:complaint_id])
      subject = SubjectDAO.find_one(complaint[:subject_id])
      status = StatusDAO.find_one(data[:status_id])
    rescue => e
      puts "Error al obtener detalles de la queja, asunto o estado: #{e.message}"
      return { success: false, message: "Error al obtener detalles de la queja, asunto o estado" }.to_json
    end

    begin
      Notifier.notify_status_change(usuario[:email], status[:name], 'ILM0002', usuario[:first_name], subject[:name], change[:dateofcreation])
      { success: true, message: "Cambio registrado", data: change }.to_json
    rescue => e
      puts "Error al enviar notificación de cambio de estado: #{e.message}"
      { success: false, message: "Error al enviar notificación de cambio de estado" }.to_json
    end
  end
end
