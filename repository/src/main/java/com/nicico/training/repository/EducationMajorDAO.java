package com.nicico.training.repository;

import com.nicico.training.model.EducationMajor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface EducationMajorDAO extends JpaRepository<EducationMajor, Long>, JpaSpecificationExecutor<EducationMajor> {
    @Modifying
    @Query(value = "select * from TBL_EDUCATION_MAJOR where C_TITLE_FA = :titleFa", nativeQuery = true)
    @Transactional
    List<EducationMajor> findByTitleFa(@Param("titleFa") String titleFa);
}
