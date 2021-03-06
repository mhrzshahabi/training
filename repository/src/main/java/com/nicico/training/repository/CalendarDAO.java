package com.nicico.training.repository;

import com.nicico.training.model.AcademicBK;
import com.nicico.training.model.Calendar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CalendarDAO extends JpaRepository<Calendar, Long>, JpaSpecificationExecutor<Calendar> {
}
