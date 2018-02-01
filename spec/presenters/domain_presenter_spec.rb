# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DomainPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, model) }
  let(:user) { build(:user) }
  let(:policy) { DomainsPolicy.new([SubjectPolicyAgent.new(:User, user), DomainPolicyAgent.new(model)]) }
  let(:model) { build(:domain, display_name: display_name, parent: parent, children: children, publishers: publishers) }
  let(:display_name) { nil }
  let(:parent) { nil }
  let(:children) { [] }
  let(:publishers) { [] }

  it { is_expected.to be_a(described_class) }

  context 'user delegation' do
    before do
    end
    it do
      expect(subject.user).to be user
    end
  end

  context 'policy delegation' do
    before do
    end
    it do
      expect(subject.policy).to be policy
    end
  end

  context 'model delegation' do
    before do
    end
    it do
      expect(subject.model).to be model
      expect(subject.name).to be model.name
      expect(subject.display_name).to be model.display_name
    end
  end

  describe '#label' do
    subject { presenter.label }
    it { is_expected.to be_a(String) }
    context 'blank' do
      let(:display_name) { nil }
      it { is_expected.to eq 'DOMAIN' }
    end
    context 'present' do
      let(:display_name) { 'display_name' }
      it { is_expected.to eq model.display_name }
    end
  end

  describe '#parent?' do
    subject { presenter.parent? }
    context 'blank' do
      let(:parent) { nil }
      it { is_expected.to be false }
    end
    context 'present' do
      let(:parent) { build(:domain) }
      it { is_expected.to be true }
    end
  end

  describe '#parent' do
    subject { presenter.parent }
    let(:parent) { build(:domain) }
    it do
      is_expected.to be_a(DomainPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(DomainsPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be_a(DomainPolicyAgent)
      expect(subject.policy.object_agent.client_type).to eq :Domain.to_s
      expect(subject.policy.object_agent.client).to be model.parent
      expect(subject.model).to be model.parent
    end
  end

  describe '#children?' do
    subject { presenter.children? }
    context 'empty' do
      let(:children) { [] }
      it { is_expected.to be false }
    end
    context '!empty' do
      let(:children) { [build(:domain)] }
      it { is_expected.to be true }
    end
  end

  describe '#children' do
    subject { presenter.children }
    let(:children) do
      [
          build(:domain),
          build(:domain),
          build(:domain)
      ]
    end
    it do
      is_expected.to be_a(DomainsPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(DomainsPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq children.count
      subject.each.with_index do |domain, index|
        expect(domain).to be_a(DomainPresenter)
        expect(domain.user).to be user
        expect(domain.policy).to be_a(DomainsPolicy)
        expect(domain.policy.subject_agent).to be policy.subject_agent
        expect(domain.policy.object_agent).to be_a(DomainPolicyAgent)
        expect(domain.policy.object_agent.client_type).to eq :Domain.to_s
        expect(domain.policy.object_agent.client).to be children[index]
        expect(domain.model).to be children[index]
      end
    end
  end

  describe '#publishers?' do
    subject { presenter.publishers? }
    context 'empty' do
      let(:publishers) { [] }
      it { is_expected.to be false }
    end
    context '!empty' do
      let(:publishers) { [build(:publisher)] }
      it { is_expected.to be true }
    end
  end

  describe '#publishers' do
    subject { presenter.publishers }
    let(:publishers) do
      [
          build(:publisher),
          build(:publisher),
          build(:publisher)
      ]
    end
    it do
      is_expected.to be_a(PublishersPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(PublishersPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq publishers.count
      subject.each.with_index do |publisher, index|
        expect(publisher).to be_a(PublisherPresenter)
        expect(publisher.user).to be user
        expect(publisher.policy).to be_a(PublishersPolicy)
        expect(publisher.policy.subject_agent).to be policy.subject_agent
        expect(publisher.policy.object_agent).to be_a(PublisherPolicyAgent)
        expect(publisher.policy.object_agent.client_type).to eq :Publisher.to_s
        expect(publisher.policy.object_agent.client).to be publishers[index]
        expect(publisher.model).to be publishers[index]
      end
    end
  end

  describe '#domains' do
    subject { presenter.domains }
    let(:domains) do
      [
          build(:domain, id: 0),
          build(:domain, id: 1),
          build(:domain, id: 2)
      ]
    end
    before { allow(Domain).to receive(:all).and_return(domains) }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to be domains.count
      subject.each.with_index do |domain, index|
        expect(domain[0]).to be domains[index].display_name
        expect(domain[1]).to be index
      end
    end
  end
end
