package com.nicico.training.repository;


import com.nicico.training.model.ClassesReactiveAssessmentHasNotReachedQuorum;
import org.springframework.stereotype.Repository;
import java.util.Date;
import java.util.List;


@Repository
public interface ClassesReactiveAssessmentHasNotReachedQuorumDAO extends BaseDAO<ClassesReactiveAssessmentHasNotReachedQuorum, Long>{

    List<ClassesReactiveAssessmentHasNotReachedQuorum> findAllByClassStartDateBetween(Date start, Date end);
}
