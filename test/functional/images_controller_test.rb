require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup do
    @image = images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image" do
    assert_difference('Image.count') do
      post :create, image: { category: @image.category, date_end: @image.date_end, date_start: @image.date_start, description: @image.description, fileid: @image.fileid, geo_lat: @image.geo_lat, geo_lng: @image.geo_lng, imagetype: @image.imagetype, local: @image.local, origin: @image.origin, path_to_image: @image.path_to_image, title: @image.title }
    end

    assert_redirected_to image_path(assigns(:image))
  end

  test "should show image" do
    get :show, id: @image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @image
    assert_response :success
  end

  test "should update image" do
    put :update, id: @image, image: { category: @image.category, date_end: @image.date_end, date_start: @image.date_start, description: @image.description, fileid: @image.fileid, geo_lat: @image.geo_lat, geo_lng: @image.geo_lng, imagetype: @image.imagetype, local: @image.local, origin: @image.origin, path_to_image: @image.path_to_image, title: @image.title }
    assert_redirected_to image_path(assigns(:image))
  end

  test "should destroy image" do
    assert_difference('Image.count', -1) do
      delete :destroy, id: @image
    end

    assert_redirected_to images_path
  end

end
