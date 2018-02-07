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
    !@client.nil?
  end

  def client_id
    return nil if @client.nil?
    @client_id ||= :anonymous.to_s unless @client.respond_to?(:id)
    @client_id ||= :anonymous.to_s unless @client.id.present?
    @client_id ||= @client.id.to_s
    @client_id
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
    @client_instance ||= !client_type? && !client_id.nil?
    @client_instance
  end

  def client_instance_anonymous?
    @client_instance_anonymous ||= client_instance? && client_id == :anonymous.to_s
    @client_instance_anonymous
  end

  def client_instance_authenticated?
    return false unless client_instance?
    return false unless client_type == :User.to_s
    @client_instance_authenticated ||= client.authenticated?
    @client_instance_authenticated
  end

  def client_instance_identified?
    return false unless client_instance_authenticated?
    @client_instance_identified ||= client.identified?
    @client_instance_identified
  end

  def client_instance_administrative?
    return false unless client_instance_identified?
    @client_instance_administrative ||=  PolicyMaker.exists?(self, RolePolicyAgent.new(:administrator), PolicyMaker::OBJECT_ANY)
    @client_instance_administrative
  end
end
