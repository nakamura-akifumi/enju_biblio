class PatronRelationshipsController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource
  before_filter :prepare_options, :except => [:index, :destroy]

  def new
    @patron_relationship = PatronRelationship.new(params[:patron_relationship])
    @patron_relationship.parent = Patron.find(params[:patron_id]) rescue nil
    @patron_relationship.child = Patron.find(params[:child_id]) rescue nil
  end

  def update
    @patron_relationship = PatronRelationship.find(params[:id])
    if params[:move]
      move_position(@patron_relationship, params[:move])
      return
    end
    update!
  end

  private
  def prepare_options
    @patron_relationship_types = PatronRelationshipType.all
  end
end
