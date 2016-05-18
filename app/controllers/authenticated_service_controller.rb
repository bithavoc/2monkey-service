class AuthenticatedServiceController < ApplicationController
  require 'base64'

  BEARER_REGEX = /^Bearer /
  BASIC_REGEX = /^Basic /

  include ActionController::HttpAuthentication::Token

  attr_accessor :current_vault

  before_filter :load_vault

  private

  def load_vault
    fetch_current_vault
  end

  def validate_auth
    !!(fetch_current_vault || invalid)
  end

  def fetch_current_vault
    @current_vault = (vault_by_token || vault_by_password)
    return unless @current_vault
    @current_vault.new_token
  end

  def invalid
    render status: :forbidden, json: simple_error("Invalid password")
  end

  def simple_error(message)
    error = build_message("error", message, "")
    {messages: [error]}
  end

  def simple_ok(body = {})
    {messages: []}.merge(body)
  end

  def build_message(kind = "error", message = "", path = "")
    {kind: kind, message: message, path: path}
  end

  def vault_by_password
    if password_request
      vault = Vault.where(name: params["id"]).where(password: password_request).first
      vault.new_token
      vault
    end
  end

  def vault_by_token
    token = token_request
    Vault.where(token: token).first if token
  end

  def password_request
    return unless authorization_request.include? "Basic "
    password = authorization_request.sub(BASIC_REGEX, '')
    return if password.blank?
    Base64.decode64 password
  end

  def token_request
    return unless authorization_request.include? "Bearer "
    token = authorization_request.sub(BEARER_REGEX, '')
    return if token.blank?
    Base64.decode64 token
  end

  def authorization_request
    request.authorization.to_s
  end
end
