package com.nicico.training.repository;

import com.nicico.training.model.Student;
import com.nicico.training.model.ViewActivePersonnelInRegistering;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewActivePersonnelInRegisteringDAO extends BaseDAO<ViewActivePersonnelInRegistering, Long>{


    List<Student> findByPersonnelNo(String personnelNo);

}

