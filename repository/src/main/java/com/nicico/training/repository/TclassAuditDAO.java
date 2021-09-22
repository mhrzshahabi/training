package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:roya
*/

import com.nicico.training.model.Course;
import com.nicico.training.model.TClassAudit;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.compositeKey.AuditClassId;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.*;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Repository
public interface TclassAuditDAO extends JpaRepository<TClassAudit, AuditClassId>, JpaSpecificationExecutor<TClassAudit> {


    @Query(value = "select * from tbl_class_aud  where ID = :classId ORDER BY rev", nativeQuery = true)
    List<TClassAudit> getAuditData(long classId);
}