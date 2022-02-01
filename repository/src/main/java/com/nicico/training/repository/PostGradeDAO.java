package com.nicico.training.repository;

import com.nicico.training.model.PostGrade;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.Optional;

@Repository
public interface PostGradeDAO extends JpaRepository<PostGrade, Long>, JpaSpecificationExecutor<PostGrade> {

    @Modifying
    @Query(value = "update TBL_POST_GRADE set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName,N_VERSION = N_VERSION + 1 where ID = :objectId", nativeQuery = true)
    public int updateModifications(Long objectId, Date modificationDate, String userName);

    public Optional<PostGrade> findById(Long id);
}
