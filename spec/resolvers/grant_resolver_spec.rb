require 'grant_resolver'

class FakeRepository
  def grants_for(subjects, credentials, resources)
    if credentials.include?('permission:edit') && subjects.include?('user:anna')
      [['user:anna', 'permission:edit', 'listing:17']]
    elsif credentials.include?('permission:read') && subjects.include?('account-type:umich')
      [[subjects.first, 'permission:read', 'listing:17']]
    else
      []
    end
  end
end

RSpec.describe GrantResolver do

  let(:anna)    { double('User', username: 'anna', known?: true) }
  let(:katy)    { double('User', username: 'katy', known?: true) }
  let(:guest)   { double('User', username: '<guest>', known?: false) }
  let(:listing) { double('Listing', id: 17, entity_type: 'listing') }
  let(:action)  { :read }
  let(:target)  { listing }

  let(:subject_resolver)    { double('SubjectResolver', resolve: []) }
  let(:anna_resolver)       { double('SubjectResolver', resolve: ['user:anna', 'account-type:umich', 'affiliation:lib-staff']) }
  let(:katy_resolver)       { double('SubjectResolver', resolve: ['user:katy', 'account-type:umich', 'affiliation:faculty']) }
  let(:guest_resolver)      { double('SubjectResolver', resolve: ['account-type:guest']) }

  let(:credential_resolver) { double('CredentialResolver', resolve: []) }
  let(:read_resolver)       { double('CredentialResolver', resolve: ['permission:read']) }
  let(:edit_resolver)       { double('CredentialResolver', resolve: ['permission:edit']) }

  let(:resource_resolver)   { double('ResourceResolver', resolve: []) }
  let(:listing_resolver)    { double('ResourceResolver', resolve: ['listing:17', 'type:listing']) }

  subject(:resolver) {
    GrantResolver.new(user, action, target).tap do |resolver|
      resolver.subject_resolver = subject_resolver
      resolver.credential_resolver = credential_resolver
      resolver.resource_resolver = resource_resolver
      resolver.repository = FakeRepository.new
    end
  }

  context "for Anna (Library user)" do
    let(:user) { anna }
    let(:subject_resolver)  { anna_resolver }
    let(:resource_resolver) { listing_resolver }

    context "when reading listing 17" do
      let(:action) { :read }
      let(:credential_resolver) { read_resolver }

      it "finds a grant" do
        expect(resolver.any?).to be true
      end
    end

    context "when editing listing 17" do
      let(:action) { :edit }
      let(:credential_resolver) { edit_resolver }

      it "finds a grant" do
        expect(resolver.any?).to be true
      end
    end
  end

  context "for Katy (Faculty member)" do
    let(:user) { katy }
    let(:subject_resolver) { katy_resolver }

    context "when reading listing 17" do
      let(:action) { :read }
      let(:credential_resolver) { read_resolver }

      it "finds a grant" do
        expect(resolver.any?).to be true
      end
    end

    context "when editing listing 17" do
      let(:action) { :edit }
      let(:credential_resolver) { edit_resolver }

      it "does not find a grant" do
        expect(resolver.any?).to be false
      end
    end
  end

  context "for a guest user" do
    let(:user) { guest }
    let(:subject_resolver) { guest_resolver }

    context "when reading listing 17" do
      let(:action) { :read }
      let(:credential_resolver) { read_resolver }

      it "does not find any grants" do
        expect(resolver.any?).to eq false
      end
    end

    context "when editing listing 17" do
      let(:action) { :edit }
      let(:credential_resolver) { edit_resolver }

      it "does not find any grants" do
        expect(resolver.any?).to eq false
      end
    end
  end

end
