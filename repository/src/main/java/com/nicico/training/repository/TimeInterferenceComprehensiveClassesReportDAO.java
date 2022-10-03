package com.nicico.training.repository;

import com.nicico.training.model.TimeInterferenceComprehensiveClassesView;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

    @Repository
    public interface TimeInterferenceComprehensiveClassesReportDAO extends BaseDAO<TimeInterferenceComprehensiveClassesView, Long>{

        List<TimeInterferenceComprehensiveClassesView> findAllBySessionDateBetween  (Date startDate, Date endDate);
}
