class CreateDjobs < ActiveRecord::Migration
  def change
    create_table :djobs do |t|
      t.string :SCODE
      t.string :JOB
      t.string :JOBTYPE
      t.datetime :DATE
      t.string :STARTTIME
      t.integer :TRIGS
      t.string :PRICELIST
      t.string :RIGS
      t.string :PHOTOG1
      t.string :PHOTOG_NOTE
      t.string :JOB_NOTES
      t.string :LAB_NOTE
      t.string :PACK_NOTES
      t.string :LOCATION
      t.integer :PROJSALE
      t.integer :SALE
      t.integer :ESTSHOTS
      t.datetime :FLYERS
      t.datetime :NOTICES
      t.datetime :POSTERS
      t.string :NOTICE_NOTE
      t.string :CONF_CALL
      t.string :RECONFIRM_CALL
      t.string :DATA_CALL
      t.datetime :DATA_REC
      t.datetime :DATA_SETUP
      t.string :DATA2WEB
      t.datetime :LAPTOPS
      t.datetime :CROP_DATE
      t.string :CROP_NOTE
      t.datetime :TYPE_DATE
      t.string :TYPED_BY
      t.datetime :CORR_DATE
      t.string :CORR_BY
      t.string :DATA_CLEAN
      t.datetime :IMG2WEB
      t.datetime :PRINT_DATE
      t.string :PRINT_BY
      t.datetime :ID_SHIP
      t.datetime :PKS_SHIP
      t.string :PKS_NOTE
      t.datetime :MUG_SHIP
      t.datetime :CR_SHIP
      t.datetime :PICS4TEA
      t.string :CP_PROOF_PRINTED
      t.string :CP_PROOF_SHIPPED
      t.string :CP_NOTES
      t.string :CP_PROOF_RET
      t.string :CP_CORR
      t.string :CP_PRINTED
      t.string :CP_SHIP
      t.datetime :ADMIN_CD
      t.datetime :YB_UG_CD
      t.datetime :YB_SENR_CD
      t.string :PRIN_ALBUM
      t.integer :TSHOTS
      t.integer :TPKS
      t.integer :ZPKS
      t.integer :AVPK
      t.boolean :CONF_YN
      t.string :CONF

      t.timestamps
    end
  end
end
