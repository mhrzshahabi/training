package com.nicico.training.repository;

import com.nicico.training.model.EducationalCalender;
import com.nicico.training.model.Term;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface EducationalCalenderDAO extends JpaRepository<EducationalCalender, Long>, JpaSpecificationExecutor<EducationalCalender> {

     void deleteById(Long id);
}
