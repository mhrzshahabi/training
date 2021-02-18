package com.nicico.training.repository;

import com.nicico.training.model.ViewNeedAssessmentInRangeTime;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface ViewNeedAssessmentInRangeTimeDAO extends BaseDAO<ViewNeedAssessmentInRangeTime, Long>{
    List<ViewNeedAssessmentInRangeTime> findAllByUpdateAtBetween(Date start,Date end);

}
