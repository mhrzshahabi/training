package com.nicico.training.repository;

import com.nicico.training.model.EducationLicense;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface EducationLicenseDAO extends JpaRepository<EducationLicense,Long>, JpaSpecificationExecutor<EducationLicense> {
}
