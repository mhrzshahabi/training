package com.nicico.training.repository;

import com.nicico.training.model.TeachingHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeachingHistoryDAO extends JpaRepository<TeachingHistory, Long>, JpaSpecificationExecutor<TeachingHistory> {
    List<TeachingHistory> findAllByTeacherId(Long teacherId);
}
