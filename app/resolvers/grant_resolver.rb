# frozen_string_literal: true

require 'subject_resolver'
require 'credential_resolver'
require 'resource_resolver'

class GrantResolver
  attr_reader :user, :action, :target, :grants
  attr_writer :subject_resolver, :credential_resolver, :resource_resolver, :repository

  def initialize(user, action, target)
    @user = user
    @action = action
    @target = target
  end

  def any?
    # Grant.where(subject: subjects, credential: credentials, resource: resources)
    # SELECT * FROM grants
    # WHERE subject IN('user:gkostin', 'account-type:umich', 'affiliation:lib-staff')
    # AND credential IN('permission:edit')
    # AND resource IN('listing:17', 'type:listing')

    grants.any?
  end

  private

    def grants
      repository.grants_for(subjects, credentials, resources)
    end

    def subjects
      subject_resolver.resolve(user)
    end

    def credentials
      credential_resolver.resolve(action)
    end

    def resources
      resource_resolver.resolve(target)
    end

    def subject_resolver
      @subject_resolver ||= SubjectResolver.new
    end

    def credential_resolver
      @credential_resolver ||= CredentialResolver.new
    end

    def resource_resolver
      @resource_resolver ||= ResourceResolver.new
    end

    def repository
      @repository ||= GrantRepository.new
    end
end
