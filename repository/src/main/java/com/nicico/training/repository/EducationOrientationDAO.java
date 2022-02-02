package com.nicico.training.repository;

import com.nicico.training.model.EducationOrientation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface EducationOrientationDAO extends JpaRepository<EducationOrientation, Long>, JpaSpecificationExecutor<EducationOrientation> {

    @Modifying
    @Query(value = "select * from TBL_EDUCATION_ORIENTATION where C_TITLE_FA = :titleFa" +
            " and F_EDUCATION_LEVEL = :educationLevelId" +
            " and F_EDUCATION_MAJOR = :educationMajorId",
            nativeQuery = true)
    @Transactional
    List<EducationOrientation> findByTitleFaAndEducationLevelIdAAndEducationMajorId(
            @Param("titleFa") String titleFa,
            @Param("educationLevelId") Long educationLevelId,
            @Param("educationMajorId") Long educationMajorId);

    @Modifying
    @Query(value = "select * from TBL_EDUCATION_ORIENTATION where F_EDUCATION_LEVEL = :levelId and F_EDUCATION_MAJOR = :majorId", nativeQuery = true)
    @Transactional
    List<EducationOrientation> listByLevelIdAndMajorId(@Param("levelId") Long levelId, @Param("majorId") Long majorId);
}
