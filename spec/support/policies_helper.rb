# frozen_string_literal: true

module PoliciessHelper
  REQUESTORS = %i[anonymous authenticated identified administrative]
  VERB_TYPES = %i[Action Policy Role]
  VERBS = {
      Action: ActionPolicyAgent::ACTIONS,
      Policy: PolicyPolicyAgent::POLICIES,
      Role: RolePolicyAgent::ROLES
  }
  GRANTS = %i[revoke permit]

  class PolicyMatrix
    attr_accessor :matrix
    def initialize
      @matrix = {}
      REQUESTORS.each do |requestor|
        VERB_TYPES.each do |verb_type|
          VERBS[verb_type].each do |verb|
            GRANTS.each do |grant|
              matrix["#{requestor}_#{verb_type}_#{verb}_#{grant}"] = false
            end
          end
        end
      end
    end
    def expected(key)
      matrix[key] = true
    end
  end
end

#
# Matrix
#
RSpec.shared_examples 'policy matrix' do |klass, policy_matrix|
  context "#{klass} Policy" do
    subject { policy }

    let(:policy) { described_class.new([subject_agent, object_agent]) }
    let(:subject_agent) { SubjectPolicyAgent.new(:User, current_user) }
    # let(:current_user) { User.nobody }
    let(:object_agent) { ObjectPolicyAgent.new(klass, model) }
    let(:model) { double("#{klass} model") }
    let(:resolver) { double("resolver") }

    # let(:anonymous) { false }
    # let(:authenticated) { false }
    # let(:identified) { false }
    # let(:administrative) { false }

    before do
      # allow(subject_agent).to receive(:client_instance_anonymous?).and_return(anonymous)
      # allow(subject_agent).to receive(:client_instance_authenticated?).and_return(authenticated)
      # allow(subject_agent).to receive(:client_instance_identified?).and_return(identified)
      # allow(subject_agent).to receive(:client_instance_administrative?).and_return(administrative)
      # allow(PolicyResolver).to receive(:new).and_return(resolver)
      # allow(resolver).to receive(:grant?).and_return(false)
    end

    it { is_expected.to be_a ApplicationPolicy }

    PoliciessHelper::REQUESTORS.each do |requestor|
      case requestor
        when :anonymous
          let(:current_user) { User.nobody }
          let(:anonymous) { true }
          let(:authenticated) { false }
          let(:identified) { false }
          let(:administrative) { false }
        when :authenticated
          let(:current_user) { User.guest }
          let(:anonymous) { false }
          let(:authenticated) { true }
          let(:identified) { false }
          let(:administrative) { false }
        when :identified
          let(:current_user) { create(:user) }
          let(:anonymous) { false }
          let(:authenticated) { true }
          let(:identified) { true }
          let(:administrative) { false }
        when :administrative
          let(:current_user) { create(:user) }
          let(:anonymous) { false }
          let(:authenticated) { true }
          let(:identified) { true }
          let(:administrative) { true }
      end
      PoliciessHelper::VERB_TYPES.each do |verb_type|
        verbs =
            case verb_type
          when :Action
             ActionPolicyAgent::ACTIONS
              when :Policy
                PolicyPolicyAgent::POLICIES
          when :Role
            RolePolicyAgent::ROLES
        end
        verbs.each do |verb|
          let(:verb_agent) { VerbPolicyAgent.new(verb_type, verb) }

          PoliciessHelper::GRANTS.each do |grant|
          case grant
            when :revoke
              let(:grant) { false }

            when :permit
              let(:grant) { true }
          end
            it "#{requestor}_#{verb_type}_#{verb}_#{grant}" do
              expect(subject.send("#{verb}?")).to be policy_matrix.matrix["#{requestor}_#{verb_type}_#{verb}_#{grant}"]
            end
        end
          end
      end
      end
      end

end
