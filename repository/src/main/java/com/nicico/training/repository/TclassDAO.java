package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:roya
*/

import com.nicico.training.model.Tclass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TclassDAO extends JpaRepository<Tclass, Long>, JpaSpecificationExecutor<Tclass> {

    List<Tclass> findByCourseIdAndTermId(Long courseId, Long termId);

    @Modifying
    @Query(value = "update TBL_CLASS set C_WORKFLOW_ENDING_STATUS = :workflowEndingStatus, C_WORKFLOW_ENDING_STATUS_CODE = :workflowEndingStatusCode where ID = :classId", nativeQuery = true)
    public int updateClassState(Long classId, String workflowEndingStatus, Integer workflowEndingStatusCode);
}
