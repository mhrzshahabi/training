package com.nicico.training.repository;

import com.nicico.training.model.ClassSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ClassSessionDAO extends JpaRepository<ClassSession, Long >, JpaSpecificationExecutor<ClassSession> {
}
