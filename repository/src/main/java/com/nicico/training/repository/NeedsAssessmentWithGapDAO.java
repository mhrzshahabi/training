package com.nicico.training.repository;

import com.nicico.training.model.NeedsAssessmentWithGap;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;


public interface NeedsAssessmentWithGapDAO extends BaseDAO<NeedsAssessmentWithGap, Long> {


    @Modifying
    @Query(value = "SELECT\n" +
            "    * FROM tbl_needs_assessment_with_gap WHERE\n" +
            "    f_competence = :competence\n" +
            "    and\n" +
            "    c_object_type = :objectType and  f_object = :objectId \n" +
            "    ", nativeQuery = true)
    List<NeedsAssessmentWithGap> getNeedsAssessmentListForRemove(Long competence, String objectType,Long objectId);


    @Modifying
    @Query(value = "SELECT\n" +
            "    * FROM tbl_needs_assessment_with_gap WHERE\n" +
            "    f_object = :objectId\n" +
            "    and\n" +
            "    c_object_type = :objectType \n" +
            "    ", nativeQuery = true)
    List<NeedsAssessmentWithGap> getNeedsAssessmentListForSendToWorkFlow(Long objectId, String objectType);

    @Modifying
    @Query(value = "SELECT\n" +
            "               * FROM tbl_needs_assessment_with_gap WHERE\n" +
            "               f_object = :objectId\n" +
            "                and\n" +
            "                c_object_type = :objectType \n" +
            "               and\n" +
            "               n_main_workflow_status_code is null", nativeQuery = true)
    List<NeedsAssessmentWithGap> getUnCompleteData(Long objectId, String objectType);

    @Modifying
    @Query(value = "SELECT\n" +
            "               * FROM tbl_needs_assessment_with_gap WHERE\n" +
            "               f_object = :objectId\n" +
            "                and\n" +
            "                c_object_type = :objectType \n" +
            "               and\n" +
            "              ( n_main_workflow_status_code is null OR n_main_workflow_status_code = 0 )", nativeQuery = true)
    List<NeedsAssessmentWithGap> getListForChangeData(Long objectId, String objectType);


    @Modifying
    @Query(value = "delete from tbl_needs_assessment_with_gap where F_OBJECT = :objectId and C_OBJECT_TYPE = :objectType", nativeQuery = true)
    void deleteAllByObjectIdAndObjectType(Long objectId, String objectType);
}