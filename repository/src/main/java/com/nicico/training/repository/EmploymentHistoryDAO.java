package com.nicico.training.repository;

import com.nicico.training.model.EmploymentHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmploymentHistoryDAO extends JpaRepository<EmploymentHistory, Long>, JpaSpecificationExecutor<EmploymentHistory> {
    List<EmploymentHistory> findAllByTeacherId(Long teacherId);
}
