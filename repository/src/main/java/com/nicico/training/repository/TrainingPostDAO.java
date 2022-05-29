package com.nicico.training.repository;

import com.nicico.training.model.TrainingPost;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface TrainingPostDAO extends BaseDAO<TrainingPost, Long> {

    @Modifying
    @Query(value = "update TBL_TRAINING_POST set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName,N_VERSION = N_VERSION + 1 where ID = :objectId", nativeQuery = true)
    public int updateModifications(Long objectId, Date modificationDate, String userName);

    @Query(value = "SELECT DISTINCT  p.C_AREA FROM TBL_TRAINING_POST p WHERE p.C_AREA is not null order by p.C_AREA", nativeQuery = true)
    List<String> findAllArea();

    Optional<TrainingPost> findFirstByCode(String code);

    Optional<TrainingPost> findByCodeAndDeleted(@Param("code") String code, Long deleted);

}
