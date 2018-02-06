# frozen_string_literal: true

class PolicyAgent
  def initialize(client_type, client)
    @client_type = client_type
    @client = client
  end

  def client
    @client
  end

  def client?
    !client.nil?
  end

  def client_id
    return nil if @client.nil?
    return :anonymous.to_s unless @client.respond_to?(:id)
    return :anonymous.to_s unless @client.id.present?
    @client.id.to_s
  end

  def client_id?
    !client_id.nil? && client_id != :anonymous.to_s
  end

  def client_type
    return nil if @client_type.nil?
    @client_type.to_s
  end

  def client_type?
    !client_type.nil? && client_type != :unknown.to_s && client_id.nil?
  end

  def client_instance?
    !client_type? && !client_id.nil?
  end

  def client_instance_anonymous?
    client_instance? && client_id == :anonymous.to_s
  end

  def client_instance_authenticated?
    return false unless client_instance?
    return false unless client_type == :User.to_s
    client.authenticated?
  end

  def client_instance_identified?
    return false unless client_instance_authenticated?
    client.identified?
  end

  def client_instance_administrative?
    return false unless client_instance_identified?
    PolicyMaker.exists?(self, RolePolicyAgent.new(:administrator), PolicyMaker::OBJECT_ANY)
  end
end
