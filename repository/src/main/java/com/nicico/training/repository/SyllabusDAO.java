package com.nicico.training.repository;

import com.nicico.training.model.Syllabus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SyllabusDAO extends JpaRepository<Syllabus, Long>, JpaSpecificationExecutor<Syllabus> {
    List<Syllabus> findAllByGoalId(Long id);
}