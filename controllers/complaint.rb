require 'json'
require_relative '../helpers/auth_helper'
require_relative '../DAO/complaint'
require_relative '../DAO/citizen'
require_relative '../DAO/district'
require_relative '../DAO/photos'
require_relative '../DAO/administrator'
require_relative '../DAO/administrator'
require_relative '../DAO/photo'
require_relative '../DAO/subject'

class ComplaintController
  include AuthHelper

  def add_complaint(token, data)
    usuario = verificar_token(token)
    ciudadano = CitizenDAO.find_one_by_user_id(usuario[:id])

    if ciudadano
      queja = ComplaintDAO.create({
        description: data[:description],
        location_description: data[:location_description],        
        latitude: data[:latitude],
        longitude: data[:longitude],
        status_id: 1,
        citizen_id: ciudadano[:id],
        district_id: data[:district],
        subject_id: data[:subject]
      })
      
      if queja
        data[:photos].each do |photo_url|
          PhotoDAO.create({
            url: photo_url,
            complaint_id: queja[:id]
          })
        end
        { success: true, message: "Queja enviada", data: queja }.to_json
      else
        { success: false, message: "Error al crear la queja" }.to_json
      end
    else
      { success: false, message: "Ciudadano no encontrado" }.to_json
    end
  end

  def encontrar_ubicacion(queja_id)
    queja = ComplaintDAO.find_one(queja_id)
    if queja
      { success: true, message: queja[:location_description] }.to_json
    else
      { success: false, message: 'Queja no encontrada' }.to_json
    end
  end

  def encontrar_distrito(queja_id)
    queja = ComplaintDAO.find_one(queja_id)
    if queja
      district = DistrictDAO.find_one(queja[:district_id])
      { success: true, message: district[:name] }.to_json
    else
      { success: false, message: 'Queja no encontrada' }.to_json
    end
  end

  def obtener_quejas_filtradas(token, filtros)
    usuario = verificar_token(token)
    return { success: false, message: 'Token inválido' }.to_json unless usuario
  
    admin = AdministratorDAO.find_one_by_user_id(usuario[:id])
    return { success: false, message: 'Acceso denegado' }.to_json unless admin

    subject_ids = filtros[:subject_ids]
    district_ids = filtros[:district_ids]
  
    #puts "Filtros recibidos: subject_ids=#{subject_ids.inspect}, district_ids=#{district_ids.inspect}"
  
    quejas = ComplaintDAO.find_filtered(subject_ids, district_ids)
  
    if quejas && !quejas.empty?
      { success: true, data: quejas }.to_json
    else
      { success: false, message: 'No hay quejas' }.to_json
    end
  end
  
  def obtener_queja_con_detalles(id)
    queja = ComplaintDAO.find_one(id)
    if queja
      { success: true, data: queja }.to_json
    else
      { success: false, message: "Queja no encontrada" }.to_json
    end
  end

  def obtener_quejas_usuario(token)
    usuario = verificar_token(token)
    puts usuario
    ciudadano = CitizenDAO.find_one_by_user_id(usuario[:id])
    puts ciudadano

    if ciudadano
      quejas = ComplaintDAO.find_all_by_citizen_id(ciudadano[:id])
      { success: true, data: quejas }.to_json
    else
      { success: false, message: "Quejas no encontradas" }.to_json
    end
  end

  def getfullcomplaint(token, data)
    usuario = verificar_token(token)
    auxiliar = CitizenDAO.find_one_by_user_id(usuario[:id]) || AdministratorDAO.find_one_by_user_id(usuario[:id])
  
    if auxiliar
      queja = ComplaintDAO.find_one_by_complaint_id(data[:complaint_id])
  
      if queja
  
        photos = PhotoDAO.find_all_by_complaint_id(data[:complaint_id])
        queja[:photos] = photos
  
        { success: true, data: queja }.to_json
      else
        { success: false, message: "Queja no encontrada" }.to_json
      end
    else
      { success: false, message: "Usuario no autorizado o no encontrado como ciudadano o administrador" }.to_json
    end
  end 

  def actualizar_estado_queja(token, data)
    # Verificar el token
    usuario = verificar_token(token)
    return { success: false, message: 'Token inválido' }.to_json unless usuario
  
    # Verificar que el usuario es administrador
    admin = AdministratorDAO.find_one_by_user_id(usuario[:id])
    return { success: false, message: 'Acceso denegado: solo administradores pueden actualizar el estado' }.to_json unless admin
  
    # Validar la queja
    queja = ComplaintDAO.find_one(data[:complaint_id])
    return { success: false, message: 'Queja no encontrada' }.to_json unless queja
  
    # Validar el nuevo estado
    nuevo_estado = data[:new_status]
    estados_validos = [1, 2, 3] # Ejemplo: IDs válidos de estados
    unless estados_validos.include?(nuevo_estado)
      return { success: false, message: 'Estado no válido' }.to_json
    end
  
    # Actualizar el estado
    if ComplaintDAO.update_estado(data[:complaint_id], nuevo_estado)
      { success: true, message: 'Estado actualizado correctamente' }.to_json
    else
      { success: false, message: 'Error al actualizar el estado' }.to_json
    end
  end
  
  
end
