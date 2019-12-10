package com.nicico.training.repository;

import com.nicico.training.model.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public interface AttendanceDAO extends JpaRepository<Attendance, Long>, JpaSpecificationExecutor<Attendance> {
    boolean existsBySessionId(Long id);
//    List<Attendance> findAllBySessionId(ArrayList<Long> sessionIds);
    List<Attendance> findBySessionId(Long sessionId);
}