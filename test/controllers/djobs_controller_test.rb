require 'test_helper'

class DjobsControllerTest < ActionController::TestCase
  setup do
    @djob = djobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:djobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create djob" do
    assert_difference('Djob.count') do
      post :create, djob: { ADMIN_CD: @djob.ADMIN_CD, AVPK: @djob.AVPK, CONF: @djob.CONF, CONF_CALL: @djob.CONF_CALL, CONF_YN: @djob.CONF_YN, CORR_BY: @djob.CORR_BY, CORR_DATE: @djob.CORR_DATE, CP_CORR: @djob.CP_CORR, CP_NOTES: @djob.CP_NOTES, CP_PRINTED: @djob.CP_PRINTED, CP_PROOF_PRINTED: @djob.CP_PROOF_PRINTED, CP_PROOF_RET: @djob.CP_PROOF_RET, CP_PROOF_SHIPPED: @djob.CP_PROOF_SHIPPED, CP_SHIP: @djob.CP_SHIP, CROP_DATE: @djob.CROP_DATE, CROP_NOTE: @djob.CROP_NOTE, CR_SHIP: @djob.CR_SHIP, DATA2WEB: @djob.DATA2WEB, DATA_CALL: @djob.DATA_CALL, DATA_CLEAN: @djob.DATA_CLEAN, DATA_REC: @djob.DATA_REC, DATA_SETUP: @djob.DATA_SETUP, DATE: @djob.DATE, ESTSHOTS: @djob.ESTSHOTS, FLYERS: @djob.FLYERS, ID_SHIP: @djob.ID_SHIP, IMG2WEB: @djob.IMG2WEB, JOB: @djob.JOB, JOBTYPE: @djob.JOBTYPE, JOB_NOTES: @djob.JOB_NOTES, LAB_NOTE: @djob.LAB_NOTE, LAPTOPS: @djob.LAPTOPS, LOCATION: @djob.LOCATION, MUG_SHIP: @djob.MUG_SHIP, NOTICES: @djob.NOTICES, NOTICE_NOTE: @djob.NOTICE_NOTE, PACK_NOTES: @djob.PACK_NOTES, PHOTOG1: @djob.PHOTOG1, PHOTOG_NOTE: @djob.PHOTOG_NOTE, PICS4TEA: @djob.PICS4TEA, PKS_NOTE: @djob.PKS_NOTE, PKS_SHIP: @djob.PKS_SHIP, POSTERS: @djob.POSTERS, PRICELIST: @djob.PRICELIST, PRINT_BY: @djob.PRINT_BY, PRINT_DATE: @djob.PRINT_DATE, PRIN_ALBUM: @djob.PRIN_ALBUM, PROJSALE: @djob.PROJSALE, RECONFIRM_CALL: @djob.RECONFIRM_CALL, RIGS: @djob.RIGS, SALE: @djob.SALE, SCODE: @djob.SCODE, STARTTIME: @djob.STARTTIME, TPKS: @djob.TPKS, TRIGS: @djob.TRIGS, TSHOTS: @djob.TSHOTS, TYPED_BY: @djob.TYPED_BY, TYPE_DATE: @djob.TYPE_DATE, YB_SENR_CD: @djob.YB_SENR_CD, YB_UG_CD: @djob.YB_UG_CD, ZPKS: @djob.ZPKS }
    end

    assert_redirected_to djob_path(assigns(:djob))
  end

  test "should show djob" do
    get :show, id: @djob
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @djob
    assert_response :success
  end

  test "should update djob" do
    patch :update, id: @djob, djob: { ADMIN_CD: @djob.ADMIN_CD, AVPK: @djob.AVPK, CONF: @djob.CONF, CONF_CALL: @djob.CONF_CALL, CONF_YN: @djob.CONF_YN, CORR_BY: @djob.CORR_BY, CORR_DATE: @djob.CORR_DATE, CP_CORR: @djob.CP_CORR, CP_NOTES: @djob.CP_NOTES, CP_PRINTED: @djob.CP_PRINTED, CP_PROOF_PRINTED: @djob.CP_PROOF_PRINTED, CP_PROOF_RET: @djob.CP_PROOF_RET, CP_PROOF_SHIPPED: @djob.CP_PROOF_SHIPPED, CP_SHIP: @djob.CP_SHIP, CROP_DATE: @djob.CROP_DATE, CROP_NOTE: @djob.CROP_NOTE, CR_SHIP: @djob.CR_SHIP, DATA2WEB: @djob.DATA2WEB, DATA_CALL: @djob.DATA_CALL, DATA_CLEAN: @djob.DATA_CLEAN, DATA_REC: @djob.DATA_REC, DATA_SETUP: @djob.DATA_SETUP, DATE: @djob.DATE, ESTSHOTS: @djob.ESTSHOTS, FLYERS: @djob.FLYERS, ID_SHIP: @djob.ID_SHIP, IMG2WEB: @djob.IMG2WEB, JOB: @djob.JOB, JOBTYPE: @djob.JOBTYPE, JOB_NOTES: @djob.JOB_NOTES, LAB_NOTE: @djob.LAB_NOTE, LAPTOPS: @djob.LAPTOPS, LOCATION: @djob.LOCATION, MUG_SHIP: @djob.MUG_SHIP, NOTICES: @djob.NOTICES, NOTICE_NOTE: @djob.NOTICE_NOTE, PACK_NOTES: @djob.PACK_NOTES, PHOTOG1: @djob.PHOTOG1, PHOTOG_NOTE: @djob.PHOTOG_NOTE, PICS4TEA: @djob.PICS4TEA, PKS_NOTE: @djob.PKS_NOTE, PKS_SHIP: @djob.PKS_SHIP, POSTERS: @djob.POSTERS, PRICELIST: @djob.PRICELIST, PRINT_BY: @djob.PRINT_BY, PRINT_DATE: @djob.PRINT_DATE, PRIN_ALBUM: @djob.PRIN_ALBUM, PROJSALE: @djob.PROJSALE, RECONFIRM_CALL: @djob.RECONFIRM_CALL, RIGS: @djob.RIGS, SALE: @djob.SALE, SCODE: @djob.SCODE, STARTTIME: @djob.STARTTIME, TPKS: @djob.TPKS, TRIGS: @djob.TRIGS, TSHOTS: @djob.TSHOTS, TYPED_BY: @djob.TYPED_BY, TYPE_DATE: @djob.TYPE_DATE, YB_SENR_CD: @djob.YB_SENR_CD, YB_UG_CD: @djob.YB_UG_CD, ZPKS: @djob.ZPKS }
    assert_redirected_to djob_path(assigns(:djob))
  end

  test "should destroy djob" do
    assert_difference('Djob.count', -1) do
      delete :destroy, id: @djob
    end

    assert_redirected_to djobs_path
  end
end
