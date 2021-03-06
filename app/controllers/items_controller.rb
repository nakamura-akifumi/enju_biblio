# -*- encoding: utf-8 -*-
class ItemsController < ApplicationController
  load_and_authorize_resource
  before_filter :get_patron, :get_manifestation, :get_shelf, :except => [:create, :update, :destroy]
  if defined?(EnjuInventory)
    before_filter :get_inventory_file
  end
  before_filter :get_library, :get_item, :except => [:create, :update, :destroy]
  before_filter :prepare_options, :only => [:new, :edit]
  before_filter :get_version, :only => [:show]
  #before_filter :store_location
  after_filter :solr_commit, :only => [:create, :update, :destroy]
  after_filter :convert_charset, :only => :index
  cache_sweeper :item_sweeper, :only => [:create, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    query = params[:query].to_s.strip
    per_page = Item.default_per_page
    @count = {}
    if user_signed_in?
      if current_user.has_role?('Librarian')
        if params[:format] == 'csv'
          per_page = 65534
        elsif params[:mode] == 'barcode'
          per_page = 40
        end
      end
    end

    if defined?(InventoryFile)
      if @inventory_file
        if user_signed_in?
          if current_user.has_role?('Librarian')
            case params[:inventory]
            when 'not_in_catalog'
              mode = 'not_in_catalog'
            else
              mode = 'not_on_shelf'
            end
            order = 'items.id'
            @items = Item.inventory_items(@inventory_file, mode).order(order).page(params[:page]).per(per_page)
          else
            access_denied
            return
          end
        else
          redirect_to new_user_session_url
          return
        end
      end
    end

    unless @inventory_file
      search = Sunspot.new_search(Item)
      set_role_query(current_user, search)

      @query = query.dup
      unless query.blank?
        search.build do
          fulltext query
        end
      end

      patron = @patron
      manifestation = @manifestation
      shelf = @shelf
      unless params[:mode] == 'add'
        search.build do
          with(:patron_ids).equal_to patron.id if patron
          with(:manifestation_id).equal_to manifestation.id if manifestation
          with(:shelf_id).equal_to shelf.id if shelf
        end
      end

      search.build do
        order_by(:created_at, :desc)
      end

      role = current_user.try(:role) || Role.default_role
      search.build do
        with(:required_role_id).less_than_or_equal_to role.id
      end

      page = params[:page] || 1
      search.query.paginate(page.to_i, per_page)
      @items = search.execute!.results
      @count[:total] = @items.total_entries
    end

    if defined?(EnjuBarcode)
      if params[:mode] == 'barcode'
        render :action => 'barcode', :layout => false
        return
      end
    end

    flash[:page_info] = {:page => page, :query => query}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
      format.csv  { render :layout => false }
      format.atom
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    #@item = Item.find(params[:id])
    @item = @item.versions.find(@version).item if @version

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    if Shelf.real.blank?
      flash[:notice] = t('item.create_shelf_first')
      redirect_to libraries_url
      return
    end
    unless @manifestation
      flash[:notice] = t('item.specify_manifestation')
      redirect_to manifestations_url
      return
    end
    @item = Item.new
    @item.shelf = @library.shelves.first
    @item.manifestation_id = @manifestation.id if @manifestation
    if defined?(EnjuCirculation)
      @circulation_statuses = CirculationStatus.where(
        :name => [
          'In Process',
          'Available For Pickup',
          'Available On Shelf',
          'Claimed Returned Or Never Borrowed',
          'Not Available']
      ).order(:position)
      @item.circulation_status = CirculationStatus.where(:name => 'In Process').first
      @item.checkout_type = @manifestation.carrier_type.checkout_types.first
      @item.item_has_use_restriction = ItemHasUseRestriction.new
      @item.item_has_use_restriction.use_restriction = UseRestriction.where(:name => 'Not For Loan').first
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item.library_id = @item.shelf.library_id
    unless @item.use_restriction
      @item.build_item_has_use_restriction
      @item.item_has_use_restriction.use_restriction = UseRestriction.where(:name => 'Not For Loan').first
    end
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])
    manifestation = Manifestation.find(@item.manifestation_id)

    respond_to do |format|
      if @item.save
        @item.manifestation = manifestation
        Item.transaction do
          if defined?(EnjuCirculation)
            if @item.reserved?
              flash[:message] = t('item.this_item_is_reserved')
              @item.retain(current_user)
            end
          end
        end
        format.html { redirect_to(@item, :notice => t('controller.successfully_created', :model => t('activerecord.models.item'))) }
        format.json { render :json => @item, :status => :created, :location => @item }
      else
        prepare_options
        format.html { render :action => "new" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, :notice => t('controller.successfully_updated', :model => t('activerecord.models.item')) }
        format.json { head :no_content }
      else
        prepare_options
        format.html { render :action => "edit" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    manifestation = @item.manifestation
    @item.destroy

    respond_to do |format|
      flash[:notice] = t('controller.successfully_deleted', :model => t('activerecord.models.item'))
      if @item.manifestation
        format.html { redirect_to manifestation_items_url(manifestation) }
        format.json { head :no_content }
      else
        format.html { redirect_to items_url }
        format.json { head :no_content }
      end
    end
  end

  private
  def prepare_options
    @libraries = Library.real << Library.web
    if @item.new_record?
      @library = Library.real.first(:order => :position, :include => :shelves)
    else
      @library = @item.shelf.library
    end
    @shelves = @library.shelves
    @bookstores = Bookstore.all
    @budget_types = BudgetType.all
    @roles = Role.all
    if defined?(EnjuCirculation)
      @circulation_statuses = CirculationStatus.all
      @use_restrictions = UseRestriction.available
      if @manifestation
        @checkout_types = CheckoutType.available_for_carrier_type(@manifestation.carrier_type)
      else
        @checkout_types = CheckoutType.all
      end
    end
  end
end
