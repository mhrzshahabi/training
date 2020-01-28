package com.nicico.training.repository;


import com.nicico.training.model.ClassStudent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ClassStudentDAO extends JpaRepository<ClassStudent, Long>, JpaSpecificationExecutor<ClassStudent> {

}
