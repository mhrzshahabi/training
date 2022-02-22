package com.nicico.training.repository;

import com.nicico.training.model.AcademicBK;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AcademicBKDAO extends JpaRepository<AcademicBK, Long>, JpaSpecificationExecutor<AcademicBK> {

    List<AcademicBK> findAllByTeacherId(Long teacherId);
}
