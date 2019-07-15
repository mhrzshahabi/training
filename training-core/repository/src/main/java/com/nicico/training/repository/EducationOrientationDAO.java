package com.nicico.training.repository;

import com.nicico.training.model.EducationOrientation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface EducationOrientationDAO extends JpaRepository<EducationOrientation,Long>, JpaSpecificationExecutor<EducationOrientation> {
}
