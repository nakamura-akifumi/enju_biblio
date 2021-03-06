require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe CarrierTypesController do
  login_admin

  # This should return the minimal set of attributes required to create a valid
  # CarrierType. As you add validations to CarrierType, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:carrier_type)
  end

  describe "GET index" do
    it "assigns all carrier_types as @carrier_types" do
      carrier_type = CarrierType.create! valid_attributes
      get :index
      assigns(:carrier_types).should eq(CarrierType.all)
    end
  end

  describe "GET show" do
    it "assigns the requested carrier_type as @carrier_type" do
      carrier_type = CarrierType.create! valid_attributes
      get :show, :id => carrier_type.id
      assigns(:carrier_type).should eq(carrier_type)
    end
  end

  describe "GET new" do
    it "assigns a new carrier_type as @carrier_type" do
      get :new
      assigns(:carrier_type).should be_a_new(CarrierType)
    end
  end

  describe "GET edit" do
    it "assigns the requested carrier_type as @carrier_type" do
      carrier_type = CarrierType.create! valid_attributes
      get :edit, :id => carrier_type.id
      assigns(:carrier_type).should eq(carrier_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CarrierType" do
        expect {
          post :create, :carrier_type => valid_attributes
        }.to change(CarrierType, :count).by(1)
      end

      it "assigns a newly created carrier_type as @carrier_type" do
        post :create, :carrier_type => valid_attributes
        assigns(:carrier_type).should be_a(CarrierType)
        assigns(:carrier_type).should be_persisted
      end

      it "redirects to the created carrier_type" do
        post :create, :carrier_type => valid_attributes
        response.should redirect_to(CarrierType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved carrier_type as @carrier_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        CarrierType.any_instance.stub(:save).and_return(false)
        post :create, :carrier_type => {}
        assigns(:carrier_type).should be_a_new(CarrierType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        CarrierType.any_instance.stub(:save).and_return(false)
        post :create, :carrier_type => {}
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested carrier_type" do
        carrier_type = CarrierType.create! valid_attributes
        # Assuming there are no other carrier_types in the database, this
        # specifies that the CarrierType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        CarrierType.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => carrier_type.id, :carrier_type => {'these' => 'params'}
      end

      it "assigns the requested carrier_type as @carrier_type" do
        carrier_type = CarrierType.create! valid_attributes
        put :update, :id => carrier_type.id, :carrier_type => valid_attributes
        assigns(:carrier_type).should eq(carrier_type)
      end

      it "redirects to the carrier_type" do
        carrier_type = CarrierType.create! valid_attributes
        put :update, :id => carrier_type.id, :carrier_type => valid_attributes
        response.should redirect_to(carrier_type)
      end

      it "moves its position when specified" do
        carrier_type = CarrierType.create! valid_attributes
        position = carrier_type.position
        put :update, :id => carrier_type.id, :move => 'higher'
        response.should redirect_to carrier_types_url
        assigns(:carrier_type).position.should eq position - 1
      end
    end

    describe "with invalid params" do
      it "assigns the carrier_type as @carrier_type" do
        carrier_type = CarrierType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CarrierType.any_instance.stub(:save).and_return(false)
        put :update, :id => carrier_type.id, :carrier_type => {}
        assigns(:carrier_type).should eq(carrier_type)
      end

      it "re-renders the 'edit' template" do
        carrier_type = CarrierType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CarrierType.any_instance.stub(:save).and_return(false)
        put :update, :id => carrier_type.id, :carrier_type => {}
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested carrier_type" do
      carrier_type = CarrierType.create! valid_attributes
      expect {
        delete :destroy, :id => carrier_type.id
      }.to change(CarrierType, :count).by(-1)
    end

    it "redirects to the carrier_types list" do
      carrier_type = CarrierType.create! valid_attributes
      delete :destroy, :id => carrier_type.id
      response.should redirect_to(carrier_types_url)
    end
  end

end
