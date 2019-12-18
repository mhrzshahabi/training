package com.nicico.training.repository;

import com.nicico.training.model.TeacherCertification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface TeacherCertificationDAO extends JpaRepository<TeacherCertification, Long>, JpaSpecificationExecutor<TeacherCertification> {
}
