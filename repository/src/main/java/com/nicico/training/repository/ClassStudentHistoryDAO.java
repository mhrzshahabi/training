package com.nicico.training.repository;

import com.nicico.training.model.ClassStudentHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface ClassStudentHistoryDAO extends JpaRepository<ClassStudentHistory, Long>, JpaSpecificationExecutor<ClassStudentHistory> {
    List<ClassStudentHistory> findAllByTclassId(Long id);

}
